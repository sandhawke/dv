#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test files in paths with spaces and special characters
mkdir "space dir"
create_test_file 20 "space dir/test file.txt"
create_test_file 20 "space dir/test-special.txt"

# Test handling paths with spaces
$COMMAND "space dir/test file.txt" > "output 1.txt"
[ $(count_lines "output 1.txt") -eq 10 ] || exit 1

# Test handling paths with simple special characters
$COMMAND "space dir/test-special.txt" > output2.txt
[ $(count_lines output2.txt) -eq 10 ] || exit 1
