#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test handling of binary (non-text) data
printf "\000\001\002\003" | $COMMAND '\000-\003' 'ABCD' > output.txt
printf "ABCD" > expected.txt
assert_files_equal expected.txt output.txt

# Test null byte preservation
printf "hello\000world" | $COMMAND 'o' 'O' > output.txt
printf "hellO\000wOrld" > expected.txt
assert_files_equal expected.txt output.txt
