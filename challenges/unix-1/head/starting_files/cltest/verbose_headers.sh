#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file
create_test_file 15 "input.txt"

# Test verbose header mode
$COMMAND -v input.txt > output.txt

# Should contain header even for single file
grep -q "==> input.txt <==" output.txt
