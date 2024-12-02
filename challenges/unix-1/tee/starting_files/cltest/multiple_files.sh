#!/bin/bash
# Test tee writing to multiple output files

source "$PROJECT_ROOT/cltest/_common.sh"

echo "multi test" | $COMMAND file1.txt file2.txt file3.txt > stdout.txt

# Verify all files contain the input
assert_file_content "file1.txt" "multi test"
assert_file_content "file2.txt" "multi test"
assert_file_content "file3.txt" "multi test"
assert_file_content "stdout.txt" "multi test"
