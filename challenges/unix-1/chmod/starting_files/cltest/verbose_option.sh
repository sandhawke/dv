#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test verbose output
echo "content" > testfile
output=$($COMMAND -v 755 testfile)
[ -n "$output" ]
