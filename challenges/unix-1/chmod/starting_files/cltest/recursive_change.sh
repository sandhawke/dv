#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test recursive chmod
setup_test_files
$COMMAND -R 755 test_dir

check_perms test_dir 755
check_perms test_dir/file1 755
check_perms test_dir/subdir 755
check_perms test_dir/subdir/file3 755
