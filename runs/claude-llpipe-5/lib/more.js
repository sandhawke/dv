import fs from 'fs/promises'
import path from 'path'
import debug from 'debug'
import { getStdin } from './utils.js'
import { callLLM } from './llm.js'

const log = debug('llpipe:more')

export async function handleMore(configDir) {
  const historyDir = path.join(configDir, 'history')
  
  // Get latest history ID
  const entries = await fs.readdir(historyDir)
  if (entries.length === 0) {
    throw new Error('No conversation history found')
  }
  const lastId = Math.max(...entries.map(Number))
  
  // Continue from last conversation
  return handleAfter(configDir, lastId)
}
