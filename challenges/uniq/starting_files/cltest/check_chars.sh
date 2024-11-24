#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file
create_test_file "input.txt" << EOF
hello world
hello there
hello world
goodbye world
EOF

# Expected output (comparing only first 5 chars)
create_test_file "expected.txt" << EOF
hello world
goodbye world
EOF

# Run uniq with check-chars option
$COMMAND -w 5 input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
