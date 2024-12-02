#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test chmod on symbolic link
echo "content" > target_file
ln -s target_file symlink_file
$COMMAND 755 symlink_file
# Should modify the target, not the link
check_perms target_file 755 || exit 1

# Test chmod on special files (if possible as non-root)
mknod test_fifo p 2>/dev/null
if [ -p test_fifo ]; then
    $COMMAND 622 test_fifo
    check_perms test_fifo 622 || exit 1
fi

# Test chmod with no-dereference option
$COMMAND -h 777 symlink_file
# Should not change target file permissions
check_perms target_file 755 || exit 1
