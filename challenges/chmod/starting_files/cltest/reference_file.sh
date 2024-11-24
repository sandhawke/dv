#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test --reference option
echo "content" > reference_file
chmod 750 reference_file
echo "content" > target_file
$COMMAND --reference=reference_file target_file
check_perms target_file 750
