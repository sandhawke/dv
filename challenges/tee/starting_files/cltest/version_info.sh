#!/bin/bash
# Test --version option displays version information

source "$PROJECT_ROOT/cltest/_common.sh"

$COMMAND --version > version.txt

# Verify version output contains expected elements
assert_stdout_contains "tee" "version.txt"
