#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test symbolic mode changes
echo "content" > testfile
chmod 644 testfile  # Start with known permissions

# Test adding execute permission for user
$COMMAND u+x testfile
check_perms testfile 744 || {
    echo "Failed: u+x should result in 744 permissions"
    exit 1
}

# Test removing write permission for group and others
$COMMAND go-w testfile
check_perms testfile 744 || {
    echo "Failed: go-w should not change 744 permissions"
    exit 1
}

# Test more complex symbolic modes
$COMMAND a+r testfile
check_perms testfile 744 || {
    echo "Failed: a+r should not change 744 permissions"
    exit 1
}

$COMMAND u-x,g+w testfile
check_perms testfile 664 || {
    echo "Failed: u-x,g+w should result in 664 permissions"
    exit 1
}
