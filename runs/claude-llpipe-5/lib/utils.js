import { createInterface } from 'readline'

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
