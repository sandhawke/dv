#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test setting specific time with -t option
test_file="timetest.txt"

# Use UTC timezone to ensure consistent results across different systems
TZ=UTC $COMMAND -t 202012312359.59 "$test_file"

mtime=$(get_file_mtime "$test_file")
expected=1609459199  # 2020-12-31 23:59:59 UTC in epoch seconds

timestamps_equal "$mtime" "$expected" || exit 1
