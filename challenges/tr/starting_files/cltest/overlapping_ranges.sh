#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test overlapping character ranges
echo "abcdefg" | $COMMAND '[a-d][c-f]' 'XY' > output.txt
assert_output "XXYYefg" "$(cat output.txt)"

# Test with reversed ranges (should error)
if echo "test" | $COMMAND '[d-a]' 'X' 2>/dev/null; then
    echo "Expected failure with reversed range" >&2
    exit 1
fi
