import fs from 'fs/promises'
import path from 'path'
import debug from 'debug'

const log = debug('llpipe:list')

export async function handleList(configDir) {
  const historyDir = path.join(configDir, 'history')
  
  const entries = await fs.readdir(historyDir)
  const ids = entries.map(Number).sort((a, b) => a - b)
  
  for (const id of ids) {
    const stepDir = path.join(historyDir, id.toString())
    const messagesFile = path.join(stepDir, 'messages.json')
    
    try {
      const messages = JSON.parse(
        await fs.readFile(messagesFile, 'utf-8')
      )
      
      // Find first user message
      const userMsg = messages.find(m => m.role === 'user')
      const preview = userMsg 
        ? userMsg.content.slice(0, 60) + (userMsg.content.length > 60 ? '...' : '')
        : '(no user message)'
        
      console.log(`${id}\t${preview}`)
      
    } catch (error) {
      console.log(`${id}\t(error reading messages)`)
    }
  }
}
