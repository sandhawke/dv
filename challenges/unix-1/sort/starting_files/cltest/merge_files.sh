#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test merging sorted files
create_test_file "file1.txt" << EOF
apple
cherry
EOF

create_test_file "file2.txt" << EOF
banana
date
EOF

create_test_file "expected.txt" << EOF
apple
banana
cherry
date
EOF

$COMMAND -m file1.txt file2.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
