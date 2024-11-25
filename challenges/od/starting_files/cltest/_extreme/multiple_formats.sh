#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test combining multiple format options
create_test_file "input.bin"

output=$($COMMAND -t x1z input.bin)
expected="0000000 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f  >................<
0000020"

assert_output "$expected" "$output"
