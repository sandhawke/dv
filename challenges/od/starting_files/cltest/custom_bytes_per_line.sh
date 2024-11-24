#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test specifying bytes per line with -w option
create_test_file "input.bin"

output=$($COMMAND -w8 input.bin)
expected="0000000 000400 001402 002404 003406
0000010 004410 005412 006414 007416
0000020"

assert_output "$expected" "$output"
