#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test handling of nonexistent file
if $COMMAND nonexistent.txt 2>/dev/null; then
    exit 1
fi

# Error message should be printed to stderr
$COMMAND nonexistent.txt 2>error.txt
grep -q "cannot open.*nonexistent.txt" error.txt
