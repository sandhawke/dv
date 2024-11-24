#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create empty input file
touch "input.txt"

# Run uniq on empty file
$COMMAND input.txt > "output.txt"

# Verify output is empty
[ ! -s "output.txt" ]
