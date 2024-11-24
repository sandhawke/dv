#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test basic sorting of text
create_test_file "input.txt" << EOF
banana
apple
cherry
EOF

create_test_file "expected.txt" << EOF
apple
banana
cherry
EOF

$COMMAND input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
