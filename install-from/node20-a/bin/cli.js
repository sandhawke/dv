#!/usr/bin/env node
import dbg from 'debug'
import yargs from 'yargs'
import { hideBin } from 'yargs/helpers'
import { placeholder } from '../src/index.js'

const debug = dbg('mycmd:cli')

const cli = yargs(hideBin(process.argv))
      .scriptName('mycmd')
      .usage('Usage: $0 [options]')
      .version()
      .help()
      .alias('h', 'help')
      .option('verbose', {
        alias: 'v',
        type: 'boolean',
        description: 'More verbose output'
      })
      .option('quiet', {
        alias: 'q',
        type: 'boolean',
        description: 'Minimal output'
      })
      .check((argv) => {
        if (argv.quiet && argv.verbose) {
          throw new Error('Cannot use both quiet and verbose modes')
        }
        return true
      })
      .completion('completion', 'Generate completion script')

const argv = cli.parse()

debug(argv, {verbose: argv.verbose}, {quiet: argv.quier})
console.log(placeholder())

// if we need to display help, use cli.showHelp()
