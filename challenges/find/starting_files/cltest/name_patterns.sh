#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test -name with exact match
[ $($COMMAND . -name "file1.txt" | count_results) -eq 1 ]

# Test -name with wildcards
[ $($COMMAND . -name "*.txt" | count_results) -eq 5 ]

# Test -path with pattern
[ $($COMMAND . -path "*/subdir*/*" | count_results) -eq 2 ]
