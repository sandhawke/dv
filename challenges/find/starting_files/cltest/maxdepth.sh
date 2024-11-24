#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test -maxdepth 1
$COMMAND . -maxdepth 1 > depth1_results.txt
COUNT=$(cat depth1_results.txt | count_results)
# Must find at least: . dir1 dir2 symlink1
[ "$COUNT" -ge 4 ]
grep -q "dir1" depth1_results.txt
grep -q "dir2" depth1_results.txt

# Test -maxdepth 2
$COMMAND . -maxdepth 2 > depth2_results.txt
COUNT=$(cat depth2_results.txt | count_results)
# Should include previous plus contents of dir1 and dir2
[ "$COUNT" -gt $(cat depth1_results.txt | count_results) ]
grep -q "dir1/subdir1" depth2_results.txt
grep -q "dir2/subdir2" depth2_results.txt
