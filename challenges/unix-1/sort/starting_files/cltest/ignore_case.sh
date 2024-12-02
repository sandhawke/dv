#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test case-insensitive sorting
create_test_file "input.txt" << EOF
Banana
apple
Cherry
EOF

create_test_file "expected.txt" << EOF
apple
Banana
Cherry
EOF

$COMMAND -f input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
