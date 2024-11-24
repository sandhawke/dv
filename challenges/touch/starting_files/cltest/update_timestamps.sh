#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test updating timestamps of existing file
test_file="existing.txt"
create_test_file "$test_file"

old_mtime=$(get_file_mtime "$test_file")
sleep 2  # Ensure enough time passes for a distinct timestamp

$COMMAND "$test_file"

new_mtime=$(get_file_mtime "$test_file")

# Check that modification time was updated
[ "$new_mtime" -gt "$old_mtime" ] || exit 1
