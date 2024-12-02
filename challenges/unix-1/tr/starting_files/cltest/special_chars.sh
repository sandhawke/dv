#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test handling of special characters
echo "hello*world" | $COMMAND '*' '@' > output.txt
assert_output "hello@world" "$(cat output.txt)"

# Test handling of bracket characters
echo "hello[world]" | $COMMAND '[]' '()' > output.txt
assert_output "hello(world)" "$(cat output.txt)"

# Test handling of backslash
echo "hello\\world" | $COMMAND '\\' '/' > output.txt
assert_output "hello/world" "$(cat output.txt)"
