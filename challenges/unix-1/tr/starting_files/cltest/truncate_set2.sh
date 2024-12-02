#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test set2 truncation behavior
# When set2 is shorter, its last character is repeated
echo "abcde" | $COMMAND 'abcde' 'xy' > output.txt
assert_output "xyyyy" "$(cat output.txt)"
