#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test -d option with various date formats
test_file="datetime.txt"

# Use UTC timezone to ensure consistent results across different systems
TZ=UTC $COMMAND -d "2020-01-01 12:00:00" "$test_file"

mtime=$(get_file_mtime "$test_file")
expected=1577880000  # 2020-01-01 12:00:00 UTC in epoch seconds

timestamps_equal "$mtime" "$expected" || exit 1
