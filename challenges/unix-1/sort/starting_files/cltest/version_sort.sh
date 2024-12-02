#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test version number sorting
create_test_file "input.txt" << EOF
2.10
2.1
2.2
10.1
EOF

create_test_file "expected.txt" << EOF
2.1
2.2
2.10
10.1
EOF

$COMMAND -V input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
