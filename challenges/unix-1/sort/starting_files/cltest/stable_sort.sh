#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test stable sort
create_test_file "input.txt" << EOF
1 a first
1 a second
1 b first
1 b second
EOF

create_test_file "expected.txt" << EOF
1 a first
1 a second
1 b first
1 b second
EOF

$COMMAND -s -k2,2 input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
