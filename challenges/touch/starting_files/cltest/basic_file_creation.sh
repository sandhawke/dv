#!/bin/bash

# Test that touch creates a new file when it doesn't exist
test_file="newfile.txt"

$COMMAND "$test_file"

# Check if file was created
[ -f "$test_file" ] || exit 1

# Check if file is empty
[ -s "$test_file" ] && exit 1

# File should be readable and writable by owner
[ -r "$test_file" ] && [ -w "$test_file" ] || exit 1
