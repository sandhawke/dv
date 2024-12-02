#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test touching multiple files at once
file1="multi1.txt"
file2="multi2.txt"
file3="multi3.txt"

$COMMAND "$file1" "$file2" "$file3"

# All files should exist
[ -f "$file1" ] && [ -f "$file2" ] && [ -f "$file3" ] || exit 1

# All files should have same timestamp (within 1 second)
time1=$(get_file_mtime "$file1")
time2=$(get_file_mtime "$file2")
time3=$(get_file_mtime "$file3")

[ $(($time1 - $time2)) -le 1 ] && [ $(($time2 - $time3)) -le 1 ] || exit 1
