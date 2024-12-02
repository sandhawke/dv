#!/bin/bash

# Run uniq on non-existent file
$COMMAND nonexistent.txt > "output.txt" 2> "error.txt" && exit 1

# Verify error message exists
[ -s "error.txt" ]
