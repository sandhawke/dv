#!/bin/bash

# Test handling of non-existent input file
if $COMMAND nonexistent.file 2>/dev/null; then
    echo "Command should fail with non-existent file"
    exit 1
fi

# Check error message
error=$($COMMAND nonexistent.file 2>&1)
if ! echo "$error" | grep -q "No such file"; then
    echo "Expected 'No such file' error message"
    exit 1
fi
