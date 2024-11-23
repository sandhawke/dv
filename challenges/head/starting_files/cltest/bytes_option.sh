#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file
create_test_file 20 "input.txt"

# Test -c option
$COMMAND -c 100 input.txt > output1.txt
$COMMAND --bytes=100 input.txt > output2.txt

# Both outputs should be identical and exactly 100 bytes
[ $(wc -c < output1.txt) -eq 100 ] || exit 1
[ $(wc -c < output2.txt) -eq 100 ] || exit 1
cmp output1.txt output2.txt
