#!/bin/bash

# Test invalid number argument
if $COMMAND -n abc input.txt 2>/dev/null; then
    exit 1
fi

$COMMAND -n abc input.txt 2>error.txt
grep -q "invalid number.*abc" error.txt
