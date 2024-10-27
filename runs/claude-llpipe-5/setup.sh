#!/bin/bash
set -e

# Install dependencies
npm install

# Make the main program executable
chmod +x llpipe.js

# Create the default config directory
mkdir -p .llpipe/history
