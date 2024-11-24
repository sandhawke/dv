#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file with Unicode characters
create_test_file "input.txt" << EOF
café
café
résumé
résumé
piñata
piñata
EOF

# Expected output
create_test_file "expected.txt" << EOF
café
résumé
piñata
EOF

# Run uniq
$COMMAND input.txt > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
