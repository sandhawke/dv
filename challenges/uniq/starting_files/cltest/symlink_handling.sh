#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file and symlink
create_test_file "original.txt" << EOF
test1
test1
test2
EOF

ln -s original.txt link.txt

# Run uniq through symlink
$COMMAND link.txt > "output.txt"

# Verify output
create_test_file "expected.txt" << EOF
test1
test2
EOF

compare_files "output.txt" "expected.txt"
