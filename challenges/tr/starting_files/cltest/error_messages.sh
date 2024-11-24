#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test error message for missing operand
error_output=$(echo "hello" | $COMMAND 2>&1 >/dev/null)
if [[ ! "$error_output" =~ "missing operand" ]]; then
    exit 1
fi

# Test error message for extra operand
error_output=$(echo "hello" | $COMMAND 'a' 'b' 'c' 2>&1 >/dev/null)
if [[ ! "$error_output" =~ "extra operand" ]]; then
    exit 1
fi
