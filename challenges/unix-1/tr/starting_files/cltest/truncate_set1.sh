#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test -t option (truncate set1 to length of set2)
echo "abcde" | $COMMAND -t 'abcde' 'xy' > output.txt
assert_output "xycde" "$(cat output.txt)"
