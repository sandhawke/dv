#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test squeezing repeated characters
echo "hello    there" | $COMMAND -s '[:space:]' > output.txt
assert_output "hello there" "$(cat output.txt)"
