#!/bin/bash
# Test handling of large input

source "$PROJECT_ROOT/cltest/_common.sh"

# Generate 1MB of random data
dd if=/dev/urandom of=input.bin bs=1M count=1 2>/dev/null

# Process with tee
cat input.bin | $COMMAND output.bin > /dev/null

# Verify files match
cmp input.bin output.bin
