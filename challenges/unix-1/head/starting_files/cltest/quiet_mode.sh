#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create two test files
create_test_file 15 "file1.txt"
create_test_file 15 "file2.txt"

# Test quiet mode (no headers)
$COMMAND -q file1.txt file2.txt > output.txt
$COMMAND --quiet file1.txt file2.txt > output2.txt

# Should not contain headers
if grep -q "==> file1.txt <==" output.txt; then
    exit 1
fi
[ $(count_lines output.txt) -eq 20 ]  # Just 20 lines, no headers
cmp output.txt output2.txt
