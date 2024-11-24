#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input
create_test_file "input.txt" << EOF
apple
apple
banana
banana
cherry
EOF

# Expected output
create_test_file "expected.txt" << EOF
apple
banana
cherry
EOF

# Test reading from stdin
cat input.txt | $COMMAND > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
