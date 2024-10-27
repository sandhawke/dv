import fs from 'fs/promises'
import path from 'path'
import debug from 'debug'
import { getStdin } from './utils.js'
import { callLLM } from './llm.js'

const log = debug('llpipe:new')

export async function handleNew(configDir, systemFiles) {
  const historyDir = path.join(configDir, 'history')
  
  // Get next history ID
  const entries = await fs.readdir(historyDir)
  const nextId = entries.length > 0 
    ? Math.max(...entries.map(Number)) + 1 
    : 1
  
  const stepDir = path.join(historyDir, nextId.toString())
  await fs.mkdir(stepDir)
  
  // Read system prompt if files provided
  let systemPrompt = ''
  if (systemFiles.length > 0) {
    const contents = await Promise.all(
      systemFiles.map(f => fs.readFile(f, 'utf-8'))
    )
    systemPrompt = contents.join('\n')
  }
  
  // Read user input
  const userPrompt = await getStdin()
  
  // Prepare messages
  const messages = []
  if (systemPrompt) {
    messages.push({ role: 'system', content: systemPrompt })
  }
  messages.push({ role: 'user', content: userPrompt })
  
  // Save start state
  const start = {
    timestamp: new Date().toISOString(),
    command: 'new',
    systemFiles,
    userPrompt
  }
  await fs.writeFile(
    path.join(stepDir, 'start.json'),
    JSON.stringify(start, null, 2)
  )
  
  try {
    // Call LLM
    const response = await callLLM(messages, chunk => process.stdout.write(chunk))
    process.stdout.write('\n')
    
    // Save messages
    await fs.writeFile(
      path.join(stepDir, 'messages.json'),
      JSON.stringify(messages, null, 2)
    )
    
    // Save metadata
    const meta = {
      timestamp: new Date().toISOString(),
      success: true
    }
    await fs.writeFile(
      path.join(stepDir, 'meta.json'),
      JSON.stringify(meta, null, 2)
    )
    
  } catch (error) {
    // Save error details
    const errorData = {
      timestamp: new Date().toISOString(),
      error: {
        message: error.message,
        stack: error.stack
      }
    }
    await fs.writeFile(
      path.join(stepDir, 'error.json'),
      JSON.stringify(errorData, null, 2)
    )
    throw error
  }
}
