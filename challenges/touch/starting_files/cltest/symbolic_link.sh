#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test handling of symbolic links
target_file="target.txt"
link_file="link.txt"

create_test_file "$target_file"
ln -s "$target_file" "$link_file"

old_target_mtime=$(get_file_mtime "$target_file")
sleep 2

$COMMAND -h "$link_file"

new_target_mtime=$(get_file_mtime "$target_file")
new_link_mtime=$(get_file_mtime "$link_file")

# Target file should not be modified
timestamps_equal "$new_target_mtime" "$old_target_mtime" || exit 1
# Link should be newer
[ "$new_link_mtime" -gt "$old_target_mtime" ] || exit 1
