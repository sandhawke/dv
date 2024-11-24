#!/bin/bash
# Test behavior with many output files

source "$PROJECT_ROOT/cltest/_common.sh"

# Create command with many output files
cmd="$COMMAND"
for i in $(seq 1 1000); do
    cmd="$cmd file$i.txt"
done

# Should either succeed or fail gracefully
echo "test" | $cmd > stdout.txt 2> stderr.txt

# If it succeeded, check some files
if [ $? -eq 0 ]; then
    assert_file_content "file1.txt" "test"
    assert_file_content "file1000.txt" "test"
fi
