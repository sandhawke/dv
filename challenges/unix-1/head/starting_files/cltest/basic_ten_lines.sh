#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create a file with 20 lines
create_test_file 20 "input.txt"

# Test default behavior (should output first 10 lines)
$COMMAND input.txt > output.txt

# Verify output has exactly 10 lines
[ $(count_lines output.txt) -eq 10 ]
