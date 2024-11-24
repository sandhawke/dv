#!/bin/bash
# Test -a/--append option

source "$PROJECT_ROOT/cltest/_common.sh"

# Create initial file content
echo "first line" > output.txt

# Append using tee
echo "second line" | $COMMAND -a output.txt > /dev/null

# Verify both lines are present
assert_file_content "output.txt" "first line
second line"
