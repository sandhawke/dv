#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test custom field separator
create_test_file "input.txt" << EOF
2:b:x
2:a:y
1:b:z
1:a:w
EOF

create_test_file "expected.txt" << EOF
1:a:w
1:b:z
2:a:y
2:b:x
EOF

$COMMAND -t: -k1,1n -k2,2 input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
