#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test sorting multiple input files
create_test_file "file1.txt" << EOF
banana
cherry
EOF

create_test_file "file2.txt" << EOF
apple
date
EOF

create_test_file "expected.txt" << EOF
apple
banana
cherry
date
EOF

$COMMAND file1.txt file2.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
