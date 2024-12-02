#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test checking if file is sorted
create_test_file "sorted.txt" << EOF
apple
banana
cherry
EOF

create_test_file "unsorted.txt" << EOF
banana
apple
cherry
EOF

# Should succeed on sorted file
$COMMAND -c sorted.txt

# Should fail on unsorted file
if $COMMAND -c unsorted.txt; then
    echo "Expected failure on unsorted file"
    exit 1
fi
