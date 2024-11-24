#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test various path formats
mkdir -p dir1/dir2

# Relative paths
$COMMAND "dir1/file1.txt"
[ -f "dir1/file1.txt" ] || exit 1

# Absolute paths
$COMMAND "$PWD/dir1/dir2/file2.txt"
[ -f "$PWD/dir1/dir2/file2.txt" ] || exit 1

# Current directory notation
cd dir1
$COMMAND "./file3.txt"
[ -f "./file3.txt" ] || exit 1

# Parent directory notation
$COMMAND "../file4.txt"
[ -f "../file4.txt" ] || exit 1
