#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test deletion of characters
echo "hello there" | $COMMAND -d 'e' > output.txt
assert_output "hllo thr" "$(cat output.txt)"
