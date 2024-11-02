#!/usr/bin/env node

import { parseMultipartBoundary } from 'parse-multipart';
import { promises as fs } from 'fs';
import { exec } from 'child_process';
import { promisify } from 'util';
import { basename, join, resolve, relative } from 'path';
import { createInterface } from 'readline';
import ignore from 'ignore';
import { Buffer } from 'buffer';

const execAsync = promisify(exec);

async function readInput(filename) {
  if (filename === '-') {
    const chunks = [];
    for await (const chunk of process.stdin) chunks.push(chunk);
    return Buffer.concat(chunks);
  }
  return fs.readFile(filename);
}

async function loadGitignore(excludeFile) {
  const ig = ignore();
  ig.add('.git'); // Implicit pattern

  try {
    if (excludeFile) {
      const patterns = await fs.readFile(excludeFile, 'utf8');
      ig.add(patterns);
    } else if (await fs.access('.gitignore').then(() => true).catch(() => false)) {
      const patterns = await fs.readFile('.gitignore', 'utf8');
      ig.add(patterns);
    }
  } catch (err) {
    console.error('Warning: Error loading ignore patterns:', err.message);
  }
  
  return ig;
}

async function isGitTrackedAndClean(filepath) {
  try {
    // Check if file is tracked
    await execAsync(`git ls-files --error-unmatch "${filepath}"`);
    
    // Check if file has uncommitted changes
    const { stdout } = await execAsync(`git status --porcelain "${filepath}"`);
    return stdout.length === 0;
  } catch {
    return false;
  }
}

async function processFile(data) {
  // Find boundary from headers
  const headerEnd = data.indexOf('\r\n\r\n');
  if (headerEnd === -1) throw new Error('Invalid MIME format: no headers found');
  
  const headers = data.slice(0, headerEnd).toString();
  const boundaryMatch = headers.match(/boundary=(?:"([^"]+)"|([^;\s]+))/i);
  if (!boundaryMatch) throw new Error('No boundary found in MIME headers');
  
  const boundary = boundaryMatch[1] || boundaryMatch[2];
  const parts = parseMultipartBoundary(data, boundary);
  
  return parts.map(part => {
    const disposition = part.headers['content-disposition'];
    if (!disposition) return null;
    
    const nameMatch = disposition.match(/(?:file)?name=(?:"([^"]+)"|([^;\s]+))/i);
    if (!nameMatch) return null;
    
    const filename = nameMatch[1] || nameMatch[2];
    const isFormField = !disposition.includes('filename=');
    const targetPath = isFormField ? join('form-fields', filename) : filename;
    
    let content = part.data;
    if (part.headers['content-transfer-encoding']?.toLowerCase() === 'base64') {
      content = Buffer.from(content.toString(), 'base64');
    }
    
    const lastModified = part.headers['last-modified'] ? 
      new Date(part.headers['last-modified']) : null;
    
    const mode = part.headers['content-type']?.includes('application/x-executable') ? 
      0o755 : 0o644;
    
    return { targetPath, content, lastModified, mode };
  }).filter(Boolean);
}

async function main() {
  const args = process.argv.slice(2);
  const options = {
    force: args.includes('--force'),
    patch: args.includes('--patch'),
    preserve: args.includes('--preserve'),
    excludeFrom: args.find(arg => arg.startsWith('--exclude-from='))?.split('=')[1]
  };
  
  const filename = args.find(arg => !arg.startsWith('--'));
  if (!filename) {
    console.error('Usage: unpackmime [--force] [--patch] [--preserve] [--exclude-from=FILE] FILENAME|-');
    process.exit(1);
  }

  try {
    const data = await readInput(filename);
    const ig = await loadGitignore(options.excludeFrom);
    const parts = await processFile(data);
    
    // Safety checks
    for (const { targetPath } of parts) {
      const resolvedPath = resolve(targetPath);
      const relativePath = relative(process.cwd(), resolvedPath);
      
      if (relativePath.startsWith('..')) {
        throw new Error(`Security error: ${targetPath} would be outside current directory`);
      }
      
      if (ig.ignores(relativePath)) {
        throw new Error(`${targetPath} matches ignore pattern`);
      }
      
      if (!options.force && !options.patch) {
        if (await fs.access(targetPath).then(() => true).catch(() => false)) {
          if (!(options.patch && await isGitTrackedAndClean(targetPath))) {
            throw new Error(`${targetPath} already exists (use --force to overwrite)`);
          }
        }
      }
    }
    
    // Process files
    for (const { targetPath, content, lastModified, mode } of parts) {
      await fs.mkdir(dirname(targetPath), { recursive: true });
      await fs.writeFile(targetPath, content);
      await fs.chmod(targetPath, mode);
      
      if (options.preserve && lastModified) {
        try {
          await fs.utimes(targetPath, lastModified, lastModified);
        } catch (err) {
          console.error(`Warning: Could not set mtime for ${targetPath}: ${err.message}`);
        }
      }
    }
  } catch (err) {
    if (err.message.includes('Unexpected end of multipart data')) {
      console.error('\x1b[31mWarning: Archive appears to be truncated, processing available parts\x1b[0m');
    } else {
      console.error(err.message);
      process.exit(1);
    }
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
