#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test sorting by key field
create_test_file "input.txt" << EOF
2 banana
1 apple
3 cherry
EOF

create_test_file "expected.txt" << EOF
1 apple
2 banana
3 cherry
EOF

$COMMAND -k1,1n input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
