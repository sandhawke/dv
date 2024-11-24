#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test basic octal mode changes
echo "content" > testfile
$COMMAND 755 testfile
check_perms testfile 755
