#!/bin/bash
# Test -l option for line counting
output=$($COMMAND -l "$PROJECT_ROOT/cltest/_test_input.txt")

# Check format: spaces followed by number followed by filename
echo "$output" | grep -q "^ *4 .*$PROJECT_ROOT/cltest/_test_input.txt$"
