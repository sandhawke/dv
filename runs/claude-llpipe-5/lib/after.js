import fs from 'fs/promises'
import path from 'path'
import debug from 'debug'
import { getStdin } from './utils.js'
import { callLLM } from './llm.js'

const log = debug('llpipe:after')

export async function handleAfter(configDir, histId) {
  const historyDir = path.join(configDir, 'history')
  
  // Get previous messages
  const prevDir = path.join(historyDir, histId.toString())
  const messagesFile = path.join(prevDir, 'messages.json')
  
  try {
    await fs.access(messagesFile)
  } catch {
    throw new Error(`History ID ${histId} not found or incomplete`)
  }
  
  const prevMessages = JSON.parse(
    await fs.readFile(messagesFile, 'utf-8')
  )
  
  // Get next history ID
  const entries = await fs.readdir(historyDir)
  const nextId = Math.max(...entries.map(Number)) + 1
  const stepDir = path.join(historyDir, nextId.toString())
  await fs.mkdir(stepDir)
  
  // Read user input
  const userPrompt = await getStdin()
  
  // Add new message
  const messages = [...prevMessages]
  messages.push({ role: 'user', content: userPrompt })
  
  // Save start state
  const start = {
    timestamp: new Date().toISOString(),
    command: 'after',
    histId,
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
