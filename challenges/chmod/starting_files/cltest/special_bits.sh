#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test setting special permission bits
echo "content" > special_file
chmod 644 special_file

# Test setuid bit (using octal to ensure consistency)
$COMMAND 4755 special_file
check_perms special_file 4755 || exit 1

# Test setgid bit
$COMMAND 2755 special_file
check_perms special_file 2755 || exit 1

# Test sticky bit
$COMMAND 1755 special_file
check_perms special_file 1755 || exit 1
