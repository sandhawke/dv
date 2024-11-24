#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test zero-terminated lines
printf "banana\0apple\0cherry\0" > "input.txt"
printf "apple\0banana\0cherry\0" > "expected.txt"

$COMMAND -z input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
