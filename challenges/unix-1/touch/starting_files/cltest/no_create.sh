#!/bin/bash

# Test -c option to not create new file
test_file="nocreate.txt"

$COMMAND -c "$test_file"

# File should not exist
[ ! -f "$test_file" ] || exit 1
