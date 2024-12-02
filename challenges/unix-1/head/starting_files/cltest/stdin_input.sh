#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test reading from stdin
create_test_file 20 "input.txt"
cat input.txt | $COMMAND > output1.txt
$COMMAND < input.txt > output2.txt

# Both methods should produce identical output
[ $(count_lines output1.txt) -eq 10 ] || exit 1
cmp output1.txt output2.txt
