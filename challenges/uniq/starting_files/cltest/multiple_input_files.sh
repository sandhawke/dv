#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create first input file
create_test_file "input1.txt" << EOF
apple
apple
banana
EOF

# Create second input file
create_test_file "input2.txt" << EOF
cherry
cherry
date
EOF

# Expected output
create_test_file "expected.txt" << EOF
apple
banana
cherry
date
EOF

# Run uniq with concatenated input files
cat input1.txt input2.txt | $COMMAND > "output.txt"

# Compare output with expected
compare_files "output.txt" "expected.txt"
