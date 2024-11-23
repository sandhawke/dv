#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create file with zero-terminated records
create_zero_terminated_file 20 "input.txt"

# Test combination of -z and -c
$COMMAND -z -c 15 input.txt > output.txt

# Check exact byte count
[ $(wc -c < output.txt) -eq 15 ] || exit 1
