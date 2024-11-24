#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test different address radix with -A option
create_test_file "input.bin"

# Test decimal addresses
output=$($COMMAND -Ad input.bin)
expected="0000000 000400 001402 002404 003406 004410 005412 006414 007416
0000016"

assert_output "$expected" "$output"
