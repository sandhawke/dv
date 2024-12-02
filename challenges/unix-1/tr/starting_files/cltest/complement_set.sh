#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test complement flag
echo "hello 123 there" | $COMMAND -c -d '[:digit:]' > output.txt
assert_output "123" "$(cat output.txt)"
