#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file
create_test_file 20 "input.txt"

# Test header behavior when reading from pipe
cat input.txt | $COMMAND > output.txt
grep -q "==> standard input <==" output.txt && exit 1  # Should not have header

# With verbose flag, should show header for stdin
cat input.txt | $COMMAND -v > output2.txt
grep -q "==> standard input <==" output2.txt || exit 1
