#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input file
create_test_file "input.txt" << EOF
line1
line1
line2
EOF

# Run multiple uniq instances simultaneously
$COMMAND input.txt > "output1.txt" &
$COMMAND input.txt > "output2.txt" &

# Wait for both processes to complete
wait

# Verify both outputs are correct
create_test_file "expected.txt" << EOF
line1
line2
EOF

compare_files "output1.txt" "expected.txt" &&
compare_files "output2.txt" "expected.txt"
