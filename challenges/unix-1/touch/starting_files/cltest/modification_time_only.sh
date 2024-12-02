#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test -m option to change only modification time
test_file="mtime.txt"
create_test_file "$test_file"

old_mtime=$(get_file_mtime "$test_file")
old_atime=$(get_file_atime "$test_file")
sleep 2

$COMMAND -m "$test_file"

new_mtime=$(get_file_mtime "$test_file")
new_atime=$(get_file_atime "$test_file")

# Check that only modification time changed
[ "$new_mtime" -gt "$old_mtime" ] || exit 1
timestamps_equal "$new_atime" "$old_atime" || exit 1
