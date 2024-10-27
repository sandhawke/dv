#!/usr/bin/env node

import yargs from 'yargs'
import { hideBin } from 'yargs/helpers'
import debug from 'debug'
import { fileURLToPath } from 'url'
import path from 'path'
import fs from 'fs/promises'
import { createInterface } from 'readline'

import { handleNew } from './lib/new.js'
import { handleMore } from './lib/more.js'
import { handleAfter } from './lib/after.js'
import { handleList } from './lib/list.js'
import { handlePull } from './lib/pull.js'

const log = debug('llpipe')

// Get config directory
const configDir = process.env.LLPIPE_CONFIG || './.llpipe'
log('Using config directory:', configDir)

async function main() {
  const argv = await yargs(hideBin(process.argv))
    .command('new [files..]', 'Start new conversation', (yargs) => {
      yargs.positional('files', {
        describe: 'Files to use as system prompt',
        type: 'string'
      })
    })
    .command('more', 'Continue last conversation')
    .command('after <histid>', 'Continue from specific history ID', (yargs) => {
      yargs.positional('histid', {
        describe: 'History ID to continue from',
        type: 'number'
      })
    })
    .command('list', 'List conversation history')
    .command('pull <histid>', 'Show response from history ID', (yargs) => {
      yargs.positional('histid', {
        describe: 'History ID to pull',
        type: 'number'
      })
    })
    .demandCommand(1)
    .strict()
    .version()
    .argv

  const command = argv._[0]

  try {
    switch (command) {
      case 'new':
        await handleNew(configDir, argv.files || [])
        break
      case 'more':
        await handleMore(configDir)
        break
      case 'after':
        await handleAfter(configDir, argv.histid)
        break
      case 'list':
        await handleList(configDir)
        break
      case 'pull':
        await handlePull(configDir, argv.histid)
        break
      default:
        console.error('Unknown command:', command)
        process.exit(1)
    }
  } catch (error) {
    console.error('Error:', error.message)
    process.exit(1)
  }
}

main()
