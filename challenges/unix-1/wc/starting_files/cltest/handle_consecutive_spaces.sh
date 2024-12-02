#!/bin/bash
source "$PROJECT_ROOT/cltest/_setup.sh"

# Create file with multiple consecutive spaces and tabs
create_test_file "spaces.txt" "word1    word2		word3   	word4"

output=$($COMMAND -w spaces.txt)
[ $? -eq 0 ] || exit 1

# Should count 4 words regardless of space type
count=$(echo "$output" | awk '{print $1}')
[ "$count" -eq 4 ] || exit 1
