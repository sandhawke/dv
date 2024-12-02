#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test octal sequence handling
echo "hello" | $COMMAND e '\145' > output.txt
assert_output "hello" "$(cat output.txt)"
