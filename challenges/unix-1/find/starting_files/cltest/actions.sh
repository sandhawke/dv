#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test -print action (default)
# Count should include: 5 files, 5 dirs (including .), 1 symlink
INITIAL_COUNT=$($COMMAND . -print | count_results)
[ $INITIAL_COUNT -eq 11 ]

# Test -ls action
$COMMAND . -ls > ls_output.txt
[ $? -eq 0 ] && [ -s ls_output.txt ]

# Test -exec
# Count regular files, including ls_output.txt
$COMMAND . -type f -exec echo "Found: {}" \; > exec_output.txt
[ $? -eq 0 ]
FILE_COUNT=$($COMMAND . -type f | count_results)
EXEC_COUNT=$(cat exec_output.txt | count_results)
[ $FILE_COUNT -eq $EXEC_COUNT ]
