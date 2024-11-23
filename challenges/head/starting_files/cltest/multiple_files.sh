#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create two test files
create_test_file 15 "file1.txt"
create_test_file 15 "file2.txt"

# Test multiple file handling
$COMMAND file1.txt file2.txt > output.txt

# Should contain headers and proper content
grep -q "==> file1.txt <==" output.txt || exit 1
grep -q "==> file2.txt <==" output.txt || exit 1

# Count actual content lines (excluding headers and blank lines)
content_lines=$(grep "^Line" output.txt | wc -l)
[ "$content_lines" -eq 20 ] || exit 1  # Should be 10 lines from each file

# Headers should be properly formatted
grep -A1 "^==>" output.txt | grep -q "Line 1" || exit 1  # Content follows headers
