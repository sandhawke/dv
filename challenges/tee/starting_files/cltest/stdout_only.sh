#!/bin/bash
# Test tee with no output files specified (stdout only)

source "$PROJECT_ROOT/cltest/_common.sh"

echo "test data" | $COMMAND > stdout.txt

# Verify stdout contains the input
assert_file_content "stdout.txt" "test data"
