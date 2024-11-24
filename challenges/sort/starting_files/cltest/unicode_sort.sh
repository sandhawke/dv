#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test sorting Unicode text
create_test_file "input.txt" << EOF
über
äpfel
zebra
EOF

create_test_file "expected.txt" << EOF
äpfel
über
zebra
EOF

LC_ALL=en_US.UTF-8 $COMMAND input.txt > "output.txt"

assert_files_equal "expected.txt" "output.txt"
