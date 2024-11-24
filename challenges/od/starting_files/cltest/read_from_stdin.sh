#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test reading from standard input
create_test_file "input.bin"

output=$(cat input.bin | $COMMAND)
expected="0000000 000400 001402 002404 003406 004410 005412 006414 007416
0000020"

assert_output "$expected" "$output"
