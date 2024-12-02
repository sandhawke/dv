#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test handling of . in paths
$COMMAND . -name "." > dot_results.txt
grep -q "\.$" dot_results.txt

# Test handling of multiple starting points
$COMMAND dir1 dir2 -type f > multi_start.txt
COUNT=$(cat multi_start.txt | count_results)
[ "$COUNT" -ge 5 ]
grep -q "dir1/" multi_start.txt
grep -q "dir2/" multi_start.txt

# Test absolute path handling
ABSDIR=$(pwd)/dir1
$COMMAND "$ABSDIR" -type f > abs_path.txt
COUNT=$(cat abs_path.txt | count_results)
[ "$COUNT" -ge 3 ]
