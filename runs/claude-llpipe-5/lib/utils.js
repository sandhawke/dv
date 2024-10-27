import { createInterface } from 'readline'
import fs from 'fs/promises'
import path from 'path'

export async function getStdin() {
  if (process.stdin.isTTY) {
    return ''
  }
  
  let input = ''
  const rl = createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
  })
  
  for await (const line of rl) {
    input += line + '\n'
  }
  
  return input.trim()
}

export async function writeHistoryFiles(stepDir, data) {
  const { messages, meta, error } = data
  
  if (messages) {
    await fs.writeFile(
      path.join(stepDir, 'messages.json'),
      JSON.stringify(messages, null, 2)
    )
  }

  if (meta) {
    await fs.writeFile(
      path.join(stepDir, 'meta.json'),
      JSON.stringify({
        timestamp: new Date().toISOString(),
        ...meta
      }, null, 2)
    )
  }

  if (error) {
    await fs.writeFile(
      path.join(stepDir, 'error.json'),
      JSON.stringify({
        timestamp: new Date().toISOString(),
        error: {
          message: error.message,
          stack: error.stack,
          details: error.details
        }
      }, null, 2)
    )
  }
}
