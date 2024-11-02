#!/usr/bin/env node

import { readFile, writeFile, stat, utimes } from 'fs/promises';
import { existsSync } from 'fs';
import { exec } from 'child_process';
import { promisify } from 'util';
import { dirname } from 'path';
import { mkdir } from 'fs/promises';
import { createInterface } from 'readline';
import { createReadStream } from 'fs';
import minimist from 'minimist';

const execAsync = promisify(exec);

async function loadExcludePatterns(excludeFromFile) {
  let patterns = ['.git']; // Always exclude .git
  
  if (excludeFromFile) {
    try {
      const content = await readFile(excludeFromFile, 'utf8');
      patterns = patterns.concat(content.split('\n').filter(line => line.trim() && !line.startsWith('#')));
    } catch (err) {
      console.error(`Error reading exclude patterns file: ${err.message}`);
      process.exit(1);
    }
  } else if (existsSync('.gitignore')) {
    try {
      const content = await readFile('.gitignore', 'utf8');
      patterns = patterns.concat(content.split('\n').filter(line => line.trim() && !line.startsWith('#')));
    } catch (err) {
      console.error(`Error reading .gitignore: ${err.message}`);
      process.exit(1);
    }
  }
  
  return patterns;
}

function isPathExcluded(path, patterns) {
  // Simple pattern matching - could be enhanced with proper gitignore syntax
  return patterns.some(pattern => {
    if (pattern.startsWith('/')) {
      return path.startsWith(pattern.slice(1));
    }
    return path.includes(pattern);
  });
}

async function isFileGitTrackedAndClean(filepath) {
  try {
    // Check if file is tracked
    const { stdout: trackedOutput } = await execAsync(`git ls-files --error-unmatch "${filepath}"`);
    if (!trackedOutput.trim()) return false;

    // Check if file has uncommitted changes
    const { stdout: statusOutput } = await execAsync(`git status --porcelain "${filepath}"`);
    return !statusOutput.trim();
  } catch {
    return false;
  }
}

function decodeBase64(str) {
  return Buffer.from(str, 'base64');
}

async function ensureDirectoryExists(filepath) {
  const dir = dirname(filepath);
  await mkdir(dir, { recursive: true });
}

async function main() {
  const argv = minimist(process.argv.slice(2));
  
  if (argv._.length !== 1) {
    console.error('Usage: unpackmime [--force] [--patch] [--preserve] [--exclude-from=file] filename');
    process.exit(1);
  }

  const filename = argv._[0];
  const force = argv.force;
  const patch = argv.patch;
  const preserve = argv.preserve;
  const excludeFromFile = argv['exclude-from'];

  const excludePatterns = await loadExcludePatterns(excludeFromFile);
  
  // First pass: collect all parts and validate paths
  const parts = [];
  let boundary = null;
  let currentPart = null;
  
  const input = filename === '-' ? process.stdin : createReadStream(filename);
  const rl = createInterface({ input });

  for await (let line of rl) {
    line = line.trimRight(); // Handle both CRLF and LF
    console.log({line})

    if (!boundary && line.startsWith('--')) {
      boundary = line;
      continue;
    }

    if (boundary && line === boundary) {
      if (currentPart) {
        parts.push(currentPart);
      }
      currentPart = { headers: {}, content: [] };
      continue;
    }

    if (boundary && line === boundary + '--') {
      if (currentPart) {
        parts.push(currentPart);
      }
      break;
    }

    if (!currentPart) continue;

    if (line === '') {
      currentPart.inBody = true;
      continue;
    }

    if (!currentPart.inBody) {
      const match = line.match(/^([\w-]+):\s*(.+)$/i);
      if (match) {
        const [_, name, value] = match;
        currentPart.headers[name.toLowerCase()] = value;
      }
    } else {
      currentPart.content.push(line);
    }
  }

  if (currentPart && currentPart.inBody) {
    console.warn('\x1b[31mWarning: MIME archive appears to be truncated\x1b[0m');
    parts.push(currentPart);
  }

  // Process and validate all parts before writing any files
  const filesToWrite = [];

  for (const part of parts) {
    const disposition = part.headers['content-disposition'];
    if (!disposition) continue;

    let filename = disposition.match(/(?:filename|name)="([^"]+)"/);
    if (!filename) continue;
    filename = filename[1];

    // Handle form fields
    if (disposition.startsWith('form-data;')) {
      filename = `form-fields/${filename}`;
    }

    // Validate path
    if (filename.includes('..') || filename.startsWith('/')) {
      console.error(`Error: Invalid path ${filename}`);
      process.exit(1);
    }

    if (isPathExcluded(filename, excludePatterns)) {
      console.error(`Error: Path ${filename} matches exclude pattern`);
      process.exit(1);
    }

    let content = part.content.join('\n');
    if (part.headers['content-transfer-encoding']?.toLowerCase() === 'base64') {
      content = decodeBase64(content);
    } else {
      content = Buffer.from(content);
    }

    // Check if file exists
    if (existsSync(filename)) {
      if (!force && !patch) {
        console.error(`Error: File ${filename} already exists`);
        process.exit(1);
      }
      if (patch && !(await isFileGitTrackedAndClean(filename))) {
        console.error(`Error: File ${filename} exists and has uncommitted changes`);
        process.exit(1);
      }
    }

    const fileInfo = {
      filename,
      content,
      mode: disposition.includes('executable') ? 0o755 : 0o644,
      mtime: null
    };

    if (preserve) {
      const lastMod = part.headers['last-modified'];
      if (lastMod) {
        fileInfo.mtime = new Date(lastMod);
      }
    }

    filesToWrite.push(fileInfo);
  }

  // Write all files
  for (const file of filesToWrite) {
    console.err({file})
    await ensureDirectoryExists(file.filename);
    await writeFile(file.filename, file.content, { mode: file.mode });
    if (file.mtime) {
      await utimes(file.filename, file.mtime, file.mtime);
    }
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});








