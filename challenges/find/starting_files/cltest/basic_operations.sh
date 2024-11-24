#!/bin/bash
source $(dirname "$0")/_helpers.sh

# Test basic directory traversal
setup_test_files
$COMMAND . | sort > find_results.txt

# Count entries in results, allowing for some system variation in symlink handling
# Expected: . + dir1 + dir2 + files + subdirs + symlink (possibly resolved)
COUNT=$(cat find_results.txt | count_results)
[ "$COUNT" -ge 13 ] && [ "$COUNT" -le 15 ]
