#!/bin/bash
# Test writing to special files like /dev/null

source "$PROJECT_ROOT/cltest/_common.sh"

# Write to /dev/null and a regular file
echo "test data" | $COMMAND /dev/null output.txt > stdout.txt

# Verify regular file and stdout got the data
assert_file_content "output.txt" "test data"
assert_file_content "stdout.txt" "test data"
