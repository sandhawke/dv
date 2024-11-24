#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create a 10MB file with repeated content
create_large_file "large_input.txt" 10

# Run uniq on large file
$COMMAND large_input.txt > "large_output.txt"

# Check that output exists and is smaller than input
[ -s "large_output.txt" ] && [ $(wc -c < "large_output.txt") -lt $(wc -c < "large_input.txt") ]
