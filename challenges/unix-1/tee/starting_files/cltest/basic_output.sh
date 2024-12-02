#!/bin/bash
# Test basic tee functionality - copying stdin to both stdout and a file

source "$PROJECT_ROOT/cltest/_common.sh"

echo "test data" | $COMMAND output.txt > stdout.txt

# Verify file was created and contains correct content
assert_file_content "output.txt" "test data"

# Verify stdout contains the same content
assert_file_content "stdout.txt" "test data"
