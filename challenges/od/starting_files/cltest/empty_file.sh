#!/bin/bash

# Test handling of empty input file
touch empty.file

output=$($COMMAND empty.file)
expected="0000000"

if [ "$output" != "$expected" ]; then
    echo "Expected empty file output to be '$expected', got '$output'"
    exit 1
fi
