#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file with 20 lines
create_test_file 20 "input.txt"

# Test negative line count (should print all but last 3 lines)
$COMMAND -n -3 input.txt > output.txt

# Should have 17 lines (20 - 3)
[ $(count_lines output.txt) -eq 17 ] || exit 1

# Verify content
tail -n 1 output.txt | grep -q "Line 17" || exit 1
