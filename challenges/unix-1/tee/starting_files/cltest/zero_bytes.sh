#!/bin/bash
# Test handling of zero-length input

source "$PROJECT_ROOT/cltest/_common.sh"

# Create empty input
: | $COMMAND empty.txt > stdout.txt

# Verify files exist but are empty
assert_file_exists "empty.txt"
assert_file_exists "stdout.txt"
[ ! -s empty.txt ] || exit 1
[ ! -s stdout.txt ] || exit 1
