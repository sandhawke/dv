#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test handling of empty file
touch empty.txt

$COMMAND empty.txt > "output.txt"

# Verify output is empty
if [ -s output.txt ]; then
    echo "Expected empty output file"
    exit 1
fi
