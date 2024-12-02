#!/bin/bash
# Test counting empty file
output=$($COMMAND "$PROJECT_ROOT/cltest/_empty.txt")

# Check format: three zero counts followed by filename
echo "$output" | grep -q "^ *0 *0 *0 .*$PROJECT_ROOT/cltest/_empty.txt$"
