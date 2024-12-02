#!/bin/bash
# Test counting multiple files
output=$($COMMAND "$PROJECT_ROOT/cltest/_test_input.txt" "$PROJECT_ROOT/cltest/_empty.txt")

# Check that both filenames are present
echo "$output" | grep -q "$PROJECT_ROOT/cltest/_test_input.txt"
[ $? -eq 0 ] || exit 1

echo "$output" | grep -q "$PROJECT_ROOT/cltest/_empty.txt"
[ $? -eq 0 ] || exit 1

# Check for total line
echo "$output" | grep -q "total$"
[ $? -eq 0 ] || exit 1
