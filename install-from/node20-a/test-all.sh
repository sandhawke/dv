#!/bin/bash

# Edit this file to add the commands for your environment which are
# needed to build/rebuild and test the software in this project.
# Assume it will be run as "bash test-all.sh". This file should exit
# with status 0 if and only if all tests pass.

# We are using node.js so we need these:
npm install
npm test

# Also our command-line tests, see ./cltest/README 
dv-cltest ./cltest/[a-z]*.sh
