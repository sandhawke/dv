#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test -size with exact match (100k)
[ $($COMMAND . -size 100k -type f | count_results) -eq 1 ]

# Test -size with ranges
[ $($COMMAND . -size +50k -type f | count_results) -eq 1 ]
[ $($COMMAND . -size -1k -type f | count_results) -ge 1 ]
