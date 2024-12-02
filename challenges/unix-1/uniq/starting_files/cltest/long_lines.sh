#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input with long lines
create_repeated_lines "input.txt" "$(printf 'x%.0s' {1..1000})" 3

# Run uniq
$COMMAND input.txt > "output.txt"

# Verify output has exactly one line
[ $(wc -l < "output.txt") -eq 1 ]
