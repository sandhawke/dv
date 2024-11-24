#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file
create_test_file "input.txt" << EOF
1apple
2apple
1banana
2banana
1cherry
EOF

# Expected output (skipping first character)
create_test_file "expected.txt" << EOF
1apple
1banana
1cherry
EOF

# Run uniq with skip-chars option
$COMMAND -s 1 input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
