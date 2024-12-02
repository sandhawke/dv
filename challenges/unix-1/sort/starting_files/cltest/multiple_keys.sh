#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test sorting by multiple keys
create_test_file "input.txt" << EOF
2 b
2 a
1 b
1 a
EOF

create_test_file "expected.txt" << EOF
1 a
1 b
2 a
2 b
EOF

$COMMAND -k1,1n -k2,2 input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
