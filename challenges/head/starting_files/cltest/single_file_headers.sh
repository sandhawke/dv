#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file
create_test_file 20 "input.txt"

# Test default behavior with single file (should not show header)
$COMMAND input.txt > output1.txt
! grep -q "==> input.txt <==" output1.txt || exit 1  # Header should not be present

# With verbose flag, should show header even for single file
$COMMAND -v input.txt > output2.txt
grep -q "==> input.txt <==" output2.txt || exit 1  # Header should be present

# With quiet flag, should never show header
$COMMAND -q input.txt > output3.txt
! grep -q "==> input.txt <==" output3.txt || exit 1  # Header should not be present

# Even with both -v and -q, quiet takes precedence
$COMMAND -v -q input.txt > output4.txt
! grep -q "==> input.txt <==" output4.txt || exit 1  # Header should not be present

# Each output should still contain the actual content
[ $(count_lines output1.txt) -eq 10 ] || exit 1
grep -q "Line 1" output1.txt || exit 1
