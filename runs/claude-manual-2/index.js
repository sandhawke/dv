#!/usr/bin/env node

import { readFileSync, statSync, readdirSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join, relative, resolve } from 'path';
import { isBinary } from 'istextorbinary';
import ignore from 'ignore';
import { lookup } from 'mime-types';

// Parse command line arguments
const args = process.argv.slice(2);
let baseDir = process.cwd();
let excludeFile = '.gitignore';
const formFields = new Map();
const filesToProcess = [];

// Process command line arguments
for (const arg of args) {
  if (arg.startsWith('--base=')) {
    baseDir = resolve(arg.slice(7));
  } else if (arg.startsWith('--exclude-from=')) {
    excludeFile = arg.slice(15);
  } else if (/^[a-zA-Z].*=/.test(arg)) {
    const [name, ...values] = arg.split('=');
    formFields.set(name, values.join('='));
  } else {
    filesToProcess.push(arg);
  }
}

// Set up ignore rules
let ignoreRules;
try {
  const ignoreContent = readFileSync(excludeFile, 'utf8');
  ignoreRules = ignore().add('.git/').add(ignoreContent);
} catch (e) {
  ignoreRules = ignore().add('.git/');
}

// Generate a unique boundary
function generateBoundary(files) {
  let num = 0;
  let boundary;
  let collision;
  
  do {
    boundary = `boundary-${String(num).padStart(2, '0')}`;
    collision = false;
    
    // Check both files and form field contents for boundary collisions
    for (const file of files) {
      try {
        const content = readFileSync(file);
        if (content.includes(boundary)) {
          collision = true;
          break;
        }
      } catch (e) {
        // Skip files we can't read
      }
    }
    
    // Also check form field values for boundary collisions
    if (!collision) {
      for (const [_, value] of formFields) {
        if (value.includes(boundary)) {
          collision = true;
          break;
        }
      }
    }
    
    num++;
  } while (collision);
  
  return boundary;
}

// Recursively collect files
function collectFiles(dir, base) {
  const files = [];
  
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const fullPath = join(dir, entry.name);
    const relativePath = relative(base, fullPath);
    
    if (ignoreRules.ignores(relativePath)) continue;
    
    if (entry.isDirectory()) {
      files.push(...collectFiles(fullPath, base));
    } else {
      files.push(fullPath);
    }
  }
  
  return files;
}

// Process all input paths
const allFiles = [];
for (const path of filesToProcess) {
  const fullPath = resolve(baseDir, path);
  try {
    const stats = statSync(fullPath);
    if (stats.isDirectory()) {
      allFiles.push(...collectFiles(fullPath, baseDir));
    } else {
      allFiles.push(fullPath);
    }
  } catch (e) {
    console.error(`Error processing ${path}: ${e.message}`);
  }
}

// Generate boundary
const boundary = generateBoundary(allFiles);

// Write MIME headers
process.stdout.write(`MIME-Version: 1.0\r\n`);
process.stdout.write(`Content-Type: multipart/mixed; boundary="${boundary}"\r\n\r\n`);

let totalBytes = 0;
const summary = [];

// Write form fields
for (const [name, value] of formFields) {
  const part = `--${boundary}\r\n` +
               `Content-Disposition: form-data; name="${name}"\r\n` +
               `\r\n${value}\r\n`;
  process.stdout.write(part);
  const bytes = Buffer.from(part).length;
  totalBytes += bytes;
  summary.push({ type: 'field', name, bytes });
}

// Process files
for (const file of allFiles) {
  const relativePath = relative(baseDir, file);
  const stats = statSync(file);
  const mimeType = lookup(file) || 'application/octet-stream';
  const content = readFileSync(file);
  
  // Determine if content should be base64 encoded
  const shouldBase64 = isBinary(null, content) || 
                      mimeType.startsWith('image/') ||
                      mimeType.startsWith('video/') ||
                      mimeType.startsWith('audio/');
  
  let encodedContent;
  let contentTransferEncoding = '';
  
  if (shouldBase64) {
    encodedContent = content.toString('base64');
    contentTransferEncoding = 'Content-Transfer-Encoding: base64\r\n';
  } else {
    encodedContent = content.toString('utf8');
  }
  
  const headers = [
    `--${boundary}`,
    `Content-Type: ${mimeType}`,
    `Content-Disposition: attachment; filename="${relativePath}"`,
    contentTransferEncoding,
    `X-Unix-Mode: ${(stats.mode & 0o777).toString(8)}`,
    `Last-Modified: ${stats.mtime.toUTCString()}`
  ].filter(Boolean).join('\r\n');
  
  const part = `${headers}\r\n\r\n${encodedContent}\r\n`;
  process.stdout.write(part);
  
  const bytes = Buffer.from(part).length;
  totalBytes += bytes;
  summary.push({ type: 'file', name: relativePath, bytes });
}

// Write final boundary
const finalBoundary = `--${boundary}--\r\n`;
process.stdout.write(finalBoundary);
totalBytes += Buffer.from(finalBoundary).length;

// Write summary to stderr
console.error('\nPacked contents:');
for (const item of summary) {
  console.error(`  ${item.type === 'field' ? 'Field' : 'File'}: ${item.name} (${item.bytes} bytes)`);
}
console.error(`\nTotal bytes: ${totalBytes}`);
