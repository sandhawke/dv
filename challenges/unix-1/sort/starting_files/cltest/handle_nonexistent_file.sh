#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test handling of nonexistent file
if $COMMAND nonexistent.txt; then
    echo "Expected failure on nonexistent file"
    exit 1
fi
