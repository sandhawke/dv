#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test hexadecimal output format
create_test_file "input.bin"

output=$($COMMAND -x input.bin)
expected="0000000 0100 0302 0504 0706 0908 0b0a 0d0c 0f0e
0000020"

assert_output "$expected" "$output"
