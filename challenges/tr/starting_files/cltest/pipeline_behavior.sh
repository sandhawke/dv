#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test behavior in pipeline
echo "hello world" | $COMMAND 'o' 'O' | $COMMAND 'l' 'L' > output.txt
assert_output "heLLO wOrLd" "$(cat output.txt)"

# Test with multiple operations in pipeline
echo "hello   world" | $COMMAND -s ' ' | $COMMAND 'o' 'O' > output.txt
assert_output "hellO wOrld" "$(cat output.txt)"
