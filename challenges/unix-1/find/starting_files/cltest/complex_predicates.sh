#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test complex combination of predicates
$COMMAND . \( -type f -a \( -name "*.txt" -o -size +50k \) \) \
         -a \! -path "*/subdir*/*" > complex_results.txt
[ $? -eq 0 ]

# Should match files in root dirs matching *.txt or large files
RESULT_COUNT=$(cat complex_results.txt | count_results)
[ $RESULT_COUNT -ge 3 ]
