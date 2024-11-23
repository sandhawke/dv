#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create a larger file (10000 lines)
create_large_file 10000 "large.txt"

# Test performance and correct handling
timeout 5 $COMMAND -n 100 large.txt > output.txt || exit 1
[ $(count_lines output.txt) -eq 100 ] || exit 1

# Test reading large amount from the middle
$COMMAND -n -9900 large.txt > output2.txt
[ $(count_lines output2.txt) -eq 100 ] || exit 1
