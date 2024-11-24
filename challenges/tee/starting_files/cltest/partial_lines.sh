#!/bin/bash
# Test handling of input without newline terminator

source "$PROJECT_ROOT/cltest/_common.sh"

printf "no newline" | $COMMAND partial.txt > stdout.txt

# Verify content exactly matches (no added newline)
assert_file_content "partial.txt" "no newline"
assert_file_content "stdout.txt" "no newline"
