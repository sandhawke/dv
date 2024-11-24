#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file
create_test_file "input.txt" << EOF
apple
apple
banana
EOF

# Expected output
create_test_file "expected.txt" << EOF
apple
banana
EOF

# Run uniq with output file specified
$COMMAND input.txt output.txt

# Compare output with expected
compare_files "output.txt" "expected.txt"
