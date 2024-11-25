#!/bin/bash
source "$PROJECT_ROOT/cltest/_setup.sh"

# Create file with no read permission
create_test_file "noperm.txt" "test content"
chmod 000 noperm.txt

# Should fail with appropriate error
$COMMAND noperm.txt 2>&1 | grep -q "Permission denied"
[ $? -eq 1 ]
