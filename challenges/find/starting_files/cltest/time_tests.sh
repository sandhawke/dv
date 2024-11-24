#!/bin/bash
source $(dirname "$0")/_helpers.sh

setup_test_files

# Test -mtime (modified time)
[ $($COMMAND . -mtime -1 -type f | count_results) -ge 1 ]
[ $($COMMAND . -mtime +1 -type f -name "oldfile.txt" | count_results) -eq 1 ]

# Test -newer (relative to a reference file)
touch -d "30 minutes ago" reference_file
[ $($COMMAND . -newer reference_file -type f | count_results) -ge 1 ]
