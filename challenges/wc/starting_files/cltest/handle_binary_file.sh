#!/bin/bash
source "$PROJECT_ROOT/cltest/_setup.sh"

# Create a binary file
create_binary_file "binary_test.dat"

# Test counting binary file
output=$($COMMAND "binary_test.dat")
[ $? -eq 0 ] || exit 1

# Verify counts are non-negative
echo "$output" | awk '{exit ($1 < 0 || $2 < 0 || $3 < 0)}'
