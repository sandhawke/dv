#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file with fields
create_test_file "input.txt" << EOF
1 apple pie
2 apple pie
1 cherry pie
2 cherry pie
1 date cake
EOF

# Expected output (skipping first field)
create_test_file "expected.txt" << EOF
1 apple pie
1 cherry pie
1 date cake
EOF

# Run uniq with skip-fields option
$COMMAND -f 1 input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
