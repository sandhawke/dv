#!/bin/bash
# Test handling of permission denied errors

source "$PROJECT_ROOT/cltest/_common.sh"

# Create a read-only directory
mkdir readonly
chmod 500 readonly

# Attempt to tee into a file in the read-only directory
if echo "test" | $COMMAND readonly/output.txt 2>/dev/null; then
    echo "Expected failure due to permissions"
    exit 1
fi

# Clean up
chmod 700 readonly
