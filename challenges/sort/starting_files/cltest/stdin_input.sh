#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test sorting from stdin
create_test_file "expected.txt" << EOF
apple
banana
cherry
EOF

printf "banana\napple\ncherry\n" | $COMMAND > "output.txt"

assert_files_equal "expected.txt" "output.txt"
