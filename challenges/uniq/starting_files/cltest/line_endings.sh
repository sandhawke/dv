#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create input with DOS line endings
create_test_file "dos_input.txt" << EOF | create_file_with_endings "dos_input.txt" "dos"
line1
line1
line2
EOF

# Create expected output
create_test_file "expected.txt" << EOF
line1
line2
EOF

# Run uniq on DOS-formatted file
$COMMAND dos_input.txt > "dos_output.txt"

# Compare output with expected
compare_files "dos_output.txt" "expected.txt"

# Also test with Mac (CR) line endings
create_test_file "mac_input.txt" << EOF | create_file_with_endings "mac_input.txt" "mac"
line1
line1
line2
EOF

# Run uniq on Mac-formatted file
$COMMAND mac_input.txt > "mac_output.txt"

# Compare output with expected
compare_files "mac_output.txt" "expected.txt"
