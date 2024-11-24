#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test complex symbolic mode operations
echo "content" > complex_file
chmod 644 complex_file

# Test multiple permission changes in one command
$COMMAND u+rwx,g=rx,o-rwx complex_file
check_perms complex_file 750 || exit 1

# Test relative permissions
$COMMAND a-w complex_file
check_perms complex_file 550 || exit 1

# Test adding write back for user
$COMMAND u+w complex_file
check_perms complex_file 750 || exit 1
