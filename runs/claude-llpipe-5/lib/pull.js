import fs from 'fs/promises'
import path from 'path'
import debug from 'debug'

const log = debug('llpipe:pull')

export async function handlePull(configDir, histId) {
  const historyDir = path.join(configDir, 'history')
  const stepDir = path.join(historyDir, histId.toString())
  const messagesFile = path.join(stepDir, 'messages.json')
  
  try {
    const messages = JSON.parse(
      await fs.readFile(messagesFile, 'utf-8')
    )
    
    // Find assistant response
    const assistantMsg = messages.find(m => m.role === 'assistant')
    if (!assistantMsg) {
      throw new Error('No assistant response found')
    }
    
    process.stdout.write(assistantMsg.content)
    process.stdout.write('\n')
    
  } catch (error) {
    throw new Error(`Could not read response for history ID ${histId}: ${error.message}`)
  }
}
