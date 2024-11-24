#!/bin/bash

# Test that errors go to stderr
error_output=$($COMMAND --invalid-option 2>&1 >/dev/null)
if [ -z "$error_output" ]; then
    echo "Expected error message on stderr"
    exit 1
fi

# Verify standard output is clean when error occurs
clean_output=$($COMMAND --invalid-option 2>/dev/null)
if [ ! -z "$clean_output" ]; then
    echo "Expected empty stdout on error"
    exit 1
fi
