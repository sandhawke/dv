#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test handling of many files
file_count=1000
files=()

for i in $(seq 1 $file_count); do
    files+=("file_$i.txt")
done

$COMMAND "${files[@]}"

# Verify all files were created
for f in "${files[@]}"; do
    [ -f "$f" ] || exit 1
done
