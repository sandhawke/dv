#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

test_file="tz_test.txt"

# Test with different timezone settings
export TZ="America/New_York"
$COMMAND -d "2023-01-01 12:00:00" "$test_file"
ny_time=$(get_file_mtime "$test_file")

export TZ="UTC"
$COMMAND -d "2023-01-01 12:00:00" "utc_file.txt"
utc_time=$(get_file_mtime "utc_file.txt")

# Times should differ by timezone offset
[ $((ny_time - utc_time)) -eq 18000 ] || exit 1  # 5 hours difference
