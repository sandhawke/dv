#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file with zero-width field separator
create_test_file "input.txt" << EOF
a b c
ab c
a bc
abc
EOF

# Expected output (treating empty separator)
create_test_file "expected.txt" << EOF
a b c
ab c
a bc
abc
EOF

# Run uniq with zero-width field separator
$COMMAND -f 0 input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
