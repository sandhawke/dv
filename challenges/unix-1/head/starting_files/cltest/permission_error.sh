#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create test file with no read permissions
create_test_file 20 "noaccess.txt"
chmod 000 "noaccess.txt"

# Should fail gracefully with permission error
if $COMMAND noaccess.txt 2>/dev/null; then
    exit 1
fi

# Error message should mention permission denied
$COMMAND noaccess.txt 2>error.txt
grep -q "permission denied" error.txt

chmod 644 "noaccess.txt"  # Restore permissions for cleanup
