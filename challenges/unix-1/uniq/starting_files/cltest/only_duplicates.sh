#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file
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
cherry
EOF

# Run uniq with duplicates-only option
$COMMAND -d input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
