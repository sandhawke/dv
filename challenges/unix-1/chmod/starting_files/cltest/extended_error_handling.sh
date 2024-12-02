#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Create test file
echo "test" > testfile

# Test invalid symbolic mode formats
if $COMMAND "u+z" testfile 2>/dev/null; then
    echo "Failed to reject invalid permission 'z'"
    exit 1
fi

# Test invalid octal mode
if $COMMAND "9999" testfile 2>/dev/null; then
    echo "Failed to reject invalid octal mode"
    exit 1
fi

# Test missing operand
if $COMMAND 2>/dev/null; then
    echo "Failed to reject missing operand"
    exit 1
fi

# Test missing mode argument
if $COMMAND testfile 2>/dev/null; then
    echo "Failed to reject missing mode"
    exit 1
fi

# If we get here, all error cases were handled correctly
exit 0
