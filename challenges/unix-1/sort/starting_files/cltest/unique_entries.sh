#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test unique sorting
create_test_file "input.txt" << EOF
banana
apple
banana
cherry
apple
EOF

create_test_file "expected.txt" << EOF
apple
banana
cherry
EOF

$COMMAND -u input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
