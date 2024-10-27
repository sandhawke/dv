import LLM from '@themaximalist/llm.js'
import { spawn } from 'child_process'
import debug from 'debug'

const log = debug('llpipe:llm')

export async function callLLM(messages, stream_handler) {
  const inner = process.env.LLPIPE_INNER

  if (inner) {
    log('Using LLPIPE_INNER:', inner)
    return new Promise((resolve, reject) => {
      const proc = spawn(inner, [], { shell: true })
      let output = ''
      
      proc.stdout.on('data', (data) => {
        const text = data.toString()
        output += text
        if (stream_handler) stream_handler(text)
      })

      proc.on('error', reject)
      
      proc.on('close', (code) => {
        if (code === 0) {
          messages.push({ role: 'assistant', content: output })
          resolve(output)
        } else {
          reject(new Error(`Inner command failed with code ${code}`))
        }
      })

      proc.stdin.write(JSON.stringify(messages))
      proc.stdin.end()
    })
  } else {
    log('Using LLM.js with messages:', messages)
    const response = await LLM(messages, {
      model: "claude-3-5-sonnet-latest",
      stream: true,
      stream_handler
    })
    return response
  }
}
