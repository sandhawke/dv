#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test month sorting
create_test_file "input.txt" << EOF
December
March
January
EOF

create_test_file "expected.txt" << EOF
January
March
December
EOF

$COMMAND -M input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
