#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test limiting output bytes with -N option
create_test_file "input.bin"

output=$($COMMAND -N8 input.bin)
expected="0000000 000400 001402 002404 003406
0000010"

assert_output "$expected" "$output"
