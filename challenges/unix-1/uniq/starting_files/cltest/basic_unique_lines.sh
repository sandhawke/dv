#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file with duplicate and unique lines
create_test_file "input.txt" << EOF
apple
apple
banana
cherry
cherry
date
EOF

# Expected output
create_test_file "expected.txt" << EOF
apple
banana
cherry
date
EOF

# Run uniq
$COMMAND input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
