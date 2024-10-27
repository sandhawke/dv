import { describe, it, expect } from 'vitest'
import { fileURLToPath } from 'url'
import path from 'path'
import fs from 'fs/promises'

// Test utilities
describe('Utils', () => {
  it('should create proper directory structure', async () => {
    const configDir = '.llpipe'
    try {
      await fs.access(configDir)
      await fs.access(path.join(configDir, 'history'))
    } catch {
      throw new Error('Required directories not created')
    }
  })
})
