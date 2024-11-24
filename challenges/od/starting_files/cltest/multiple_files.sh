#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test processing multiple input files
create_test_file "input1.bin"
create_test_file "input2.bin"

output=$($COMMAND input1.bin input2.bin)
expected="0000000 000400 001402 002404 003406 004410 005412 006414 007416
*
0000040"

assert_output "$expected" "$output"
