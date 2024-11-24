#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test -type f (regular files)
[ $($COMMAND . -type f | count_results) -eq 5 ]

# Test -type d (directories)
[ $($COMMAND . -type d | count_results) -eq 5 ]  # Including .

# Test -type l (symbolic links)
[ $($COMMAND . -type l | count_results) -eq 1 ]
