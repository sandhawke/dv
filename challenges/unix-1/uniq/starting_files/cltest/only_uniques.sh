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
banana
date
EOF

# Run uniq with uniques-only option
$COMMAND -u input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
