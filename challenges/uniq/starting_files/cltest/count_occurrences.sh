#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file
create_test_file "input.txt" << EOF
apple
apple
banana
cherry
cherry
cherry
date
EOF

# Expected output
create_test_file "expected.txt" << EOF
      2 apple
      1 banana
      3 cherry
      1 date
EOF

# Run uniq with count option
$COMMAND -c input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
