#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test -r option to use reference file's timestamps
reference_file="ref.txt"
test_file="test.txt"

create_test_file "$reference_file"
sleep 2
create_test_file "$test_file"

$COMMAND -r "$reference_file" "$test_file"

ref_mtime=$(get_file_mtime "$reference_file")
test_mtime=$(get_file_mtime "$test_file")

# Check that timestamps match
timestamps_equal "$ref_mtime" "$test_mtime" || exit 1
