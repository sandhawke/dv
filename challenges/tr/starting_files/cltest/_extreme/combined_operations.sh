#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test delete and squeeze operations separately first
echo "hello    there" | $COMMAND -d 'e' > output1.txt
assert_output "hllo    thr" "$(cat output1.txt)"

echo "hello    there" | $COMMAND -s ' ' > output2.txt
assert_output "hello there" "$(cat output2.txt)"

# Now test combined operations
# The order matters: delete happens before squeeze
echo "hello    there" | $COMMAND -d -s 'e' ' ' > output3.txt
assert_output "hllo thr" "$(cat output3.txt)"
