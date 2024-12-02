#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test -a (AND) operator - find .txt files that are regular files
$COMMAND . -type f -a -name "*.txt" > and_results.txt
COUNT=$(cat and_results.txt | count_results)
# Should find all .txt files
[ "$COUNT" -ge 5 ]

# Test -o (OR) operator with explicit grouping
$COMMAND . \( -name "file1.txt" -o -name "file2.txt" \) > or_results.txt
COUNT=$(cat or_results.txt | count_results)
# Should find exactly these two files
grep -q "file1.txt" or_results.txt
grep -q "file2.txt" or_results.txt
[ "$COUNT" -eq 2 ]

# Test ! (NOT) operator - files that are not directories
$COMMAND . ! -type d > not_results.txt
COUNT=$(cat not_results.txt | count_results)
# Should include all files and symlinks
[ "$COUNT" -ge 6 ]
