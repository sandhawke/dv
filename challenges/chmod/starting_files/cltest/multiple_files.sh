#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test chmod on multiple files
echo "content" > file1
echo "content" > file2
echo "content" > file3

$COMMAND 644 file1 file2 file3

check_perms file1 644
check_perms file2 644
check_perms file3 644
