#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file with 20 lines
create_test_file 20 "input.txt"

# Test -n option (both formats)
$COMMAND -n 5 input.txt > output1.txt
$COMMAND --lines=5 input.txt > output2.txt

# Verify both outputs have exactly 5 lines
[ $(count_lines output1.txt) -eq 5 ] || exit 1
[ $(count_lines output2.txt) -eq 5 ] || exit 1
cmp output1.txt output2.txt
