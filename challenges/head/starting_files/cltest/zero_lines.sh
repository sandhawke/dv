#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file
create_test_file 20 "input.txt"

# Test zero lines (should produce empty output)
$COMMAND -n 0 input.txt > output.txt
[ -f output.txt ] || exit 1
[ ! -s output.txt ]
