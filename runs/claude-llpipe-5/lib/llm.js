import LLM from '@themaximalist/llm.js'
import { spawn } from 'child_process'
import debug from 'debug'
import chalk from 'chalk'

const log = debug('llpipe:llm')

const RATE_LIMIT_DELAY = 60000 // 1 minute default backoff

export async function callLLM(messages, stream_handler) {
  const inner = process.env.LLPIPE_INNER

  if (inner) {
    log('Using LLPIPE_INNER:', inner)
    return new Promise((resolve, reject) => {
      const proc = spawn(inner, [], { shell: true })
      let output = ''
      let errorOutput = ''
      
      proc.stdout.on('data', (data) => {
        const text = data.toString()
        output += text
        if (stream_handler) stream_handler(text)
      })

      proc.stderr.on('data', (data) => {
        errorOutput += data.toString()
      })

      proc.on('error', reject)
      
      proc.on('close', (code) => {
        if (code === 0) {
          messages.push({ role: 'assistant', content: output })
          resolve(output)
        } else {
          const error = new Error(`Inner command failed with code ${code}`)
          error.stderr = errorOutput
          reject(error)
        }
      })

      proc.stdin.write(JSON.stringify(messages))
      proc.stdin.end()
    })
  } else {
    log('Using LLM.js with messages:', messages)
    try {
      const response = await LLM(messages, {
        model: "claude-3-5-sonnet-latest",
        stream: true,
        stream_handler
      })
      return response
    } catch (error) {
      if (error.message?.includes('rate limit')) {
        const waitTime = RATE_LIMIT_DELAY
        console.error(chalk.yellow(
          `Rate limit reached. Waiting ${waitTime/1000} seconds before retry.`
        ))
        await new Promise(resolve => setTimeout(resolve, waitTime))
        // Retry once
        return await LLM(messages, {
          model: "claude-3-5-sonnet-latest", 
          stream: true,
          stream_handler
        })
      }
      throw error
    }
  }
}
