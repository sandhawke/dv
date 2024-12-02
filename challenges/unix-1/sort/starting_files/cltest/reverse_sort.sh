#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test reverse sorting
create_test_file "input.txt" << EOF
apple
banana
cherry
EOF

create_test_file "expected.txt" << EOF
cherry
banana
apple
EOF

$COMMAND -r input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
