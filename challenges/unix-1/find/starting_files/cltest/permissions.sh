#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test -perm for regular files with standard permissions
COUNT=$($COMMAND . -type f -perm 644 | count_results)
[ "$COUNT" -ge 2 ]  # At least some files should have 644

# Test -perm for directories with standard permissions
COUNT=$($COMMAND . -type d -perm 755 | count_results)
[ "$COUNT" -ge 4 ]  # Most dirs should be 755

# Test -readable (all files should be readable)
COUNT=$($COMMAND . -type f -readable | count_results)
[ "$COUNT" -ge 5 ]
