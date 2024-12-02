#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test range expansion
echo "hello" | $COMMAND '[a-z]' '[A-Z]' > output.txt
assert_output "HELLO" "$(cat output.txt)"
