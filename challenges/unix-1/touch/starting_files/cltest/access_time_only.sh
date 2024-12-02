#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test -a option to change only access time
test_file="atime.txt"
create_test_file "$test_file"

old_mtime=$(get_file_mtime "$test_file")
old_atime=$(get_file_atime "$test_file")
sleep 2

$COMMAND -a "$test_file"

new_mtime=$(get_file_mtime "$test_file")
new_atime=$(get_file_atime "$test_file")

# Check that only access time changed
timestamps_equal "$new_mtime" "$old_mtime" || exit 1
[ "$new_atime" -gt "$old_atime" ] || exit 1
