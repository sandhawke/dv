#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create file with zero-terminated records
create_zero_terminated_file 20 "input.txt"

# Test zero-terminated input handling
$COMMAND -z -n 5 input.txt > output.txt

# Should have exactly 5 null characters
[ $(count_nulls output.txt) -eq 5 ] || exit 1

# Verify content format
grep -q "Record 1" output.txt || exit 1
