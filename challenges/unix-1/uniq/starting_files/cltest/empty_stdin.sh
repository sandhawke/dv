#!/bin/bash

# Test with empty stdin
$COMMAND < /dev/null > "output.txt"

# Verify empty output
[ ! -s "output.txt" ]
