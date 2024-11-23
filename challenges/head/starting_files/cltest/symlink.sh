#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file and symlink
create_test_file 20 "target.txt"
ln -s target.txt link.txt

# Test following symlink
$COMMAND link.txt > output.txt
[ $(count_lines output.txt) -eq 10 ] || exit 1

# Test when target is missing
rm target.txt
if $COMMAND link.txt 2>/dev/null; then
    exit 1
fi
