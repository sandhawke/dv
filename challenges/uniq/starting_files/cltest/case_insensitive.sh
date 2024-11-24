#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file with mixed case
create_test_file "input.txt" << EOF
Apple
apple
APPLE
Banana
banana
CHERRY
cherry
Date
EOF

# Expected output
create_test_file "expected.txt" << EOF
Apple
Banana
CHERRY
Date
EOF

# Run uniq with case-insensitive option
$COMMAND -i input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
