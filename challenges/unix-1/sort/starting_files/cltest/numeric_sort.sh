#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test numeric sorting
create_test_file "input.txt" << EOF
10
2
1
EOF

create_test_file "expected.txt" << EOF
1
2
10
EOF

$COMMAND -n input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
