#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test empty set2 (allowed with -d option)
echo "hello" | $COMMAND -d 'e' > output.txt
assert_output "hllo" "$(cat output.txt)"

# Test error handling for missing operand
if $COMMAND '' 2>/dev/null; then
    echo "Expected failure with empty operand" >&2
    exit 1
fi
