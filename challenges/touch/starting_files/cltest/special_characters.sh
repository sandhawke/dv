#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test files with spaces and special characters
files=("file with spaces.txt" "file'with'quotes.txt" "file@#$%^.txt")

for test_file in "${files[@]}"; do
    $COMMAND "$test_file"
    [ -f "$test_file" ] || exit 1
done
