#!/bin/bash
# Test handling of broken pipe

source "$PROJECT_ROOT/cltest/_common.sh"

# Create a situation where the reader closes before writer finishes
yes | $COMMAND output.txt | head -n 1 > stdout.txt

# Should exit gracefully
status=$?
assert_exit_code 0 $status

# Verify we got some output
assert_file_exists "output.txt"
assert_file_exists "stdout.txt"
