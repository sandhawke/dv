#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test skipping bytes with -j option
create_test_file "input.bin"

output=$($COMMAND -j 4 input.bin)
expected="0000004 002404 003406 004410 005412 006414 007416
0000020"

assert_output "$expected" "$output"
