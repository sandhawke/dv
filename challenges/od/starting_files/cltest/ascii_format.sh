#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test ASCII character output format
create_text_file "input.txt"

output=$($COMMAND -c input.txt)
expected="0000000   H   e   l   l   o   ,       W   o   r   l   d   !
0000015"

assert_output "$expected" "$output"
