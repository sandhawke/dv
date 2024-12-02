#!/bin/bash

# Test behavior when touching file without permissions
test_dir="noperm"
test_file="$test_dir/test.txt"

mkdir "$test_dir"
chmod 000 "$test_dir"

# Should fail with permission denied
$COMMAND "$test_file"
exit_code=$?

chmod 755 "$test_dir"  # Restore permissions for cleanup
[ $exit_code -eq 1 ] || exit 1
