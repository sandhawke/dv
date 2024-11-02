#!/usr/bin/env node

import { stdin } from 'node:process';

// Read all input from stdin as UTF-8
async function readStdin() {
  const chunks = [];
  for await (const chunk of stdin) {
    chunks.push(chunk);
  }
  return Buffer.concat(chunks).toString('utf8');
}

// Main function to process input and call Claude
async function main() {
  try {
    const input = await readStdin();
    
    if (!process.env.ANTHROPIC_API_KEY) {
      throw new Error('ANTHROPIC_API_KEY environment variable must be set');
    }
    
    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': process.env.ANTHROPIC_API_KEY,
        'anthropic-version': '2023-06-01'
      },
      body: JSON.stringify({
        model: 'claude-3-5-sonnet-latest',
        max_tokens: 8192,
        messages: [
          {
            role: 'user',
            content: input
          }
        ]
      })
    });
    
    // If LLPIPE_LOG_RESPONSE is set, log the raw HTTP response
    if (process.env.LLPIPE_LOG_RESPONSE) {
      const logData = [
        // Reconstruct response headers
        `HTTP/1.1 ${response.status} ${response.statusText}`,
        ...Array.from(response.headers.entries()).map(([k, v]) => `${k}: ${v}`),
        '',  // Empty line between headers and body
        await response.clone().text()  // Add raw body
      ].join('\n');
      
      await import('node:fs/promises').then(fs => 
        fs.writeFile(process.env.LLPIPE_LOG_RESPONSE, logData, 'utf8')
      );
    }

    if (!response.ok) {
      throw new Error(`API request failed: ${response.status} ${response.statusText}`);
    }

    const data = await response.json();
    
    // API returns array of messages, get the last one's content
    if (!data.content || !data.content[0] || !data.content[0].text) {
      throw new Error('Unexpected API response format');
    }
    
    process.stdout.write(data.content[0].text);

  } catch (error) {
    process.stderr.write(`Error: ${error.message}\n`);
    process.exit(1);
  }
}

main();
