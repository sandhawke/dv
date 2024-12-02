#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create empty file
touch empty.txt

# Should handle empty file gracefully
$COMMAND empty.txt > output.txt
[ -f output.txt ] || exit 1
[ ! -s output.txt ]
