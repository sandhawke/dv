#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test decimal format with symbolic offset
create_test_file "input.bin"

output=$($COMMAND -t d2 input.bin)
expected="0000000    256    770   1284   1798   2312   2826   3340   3854
0000020"

assert_output "$expected" "$output"
