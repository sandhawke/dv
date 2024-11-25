#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file
create_test_file 20 "input.txt"

# Test mixing -c and -n (last option should take precedence)
$COMMAND -n 5 -c 30 input.txt > output1.txt
[ $(wc -c < output1.txt) -eq 30 ] || exit 1

$COMMAND -c 30 -n 5 input.txt > output2.txt
[ $(count_lines output2.txt) -eq 5 ] || exit 1
