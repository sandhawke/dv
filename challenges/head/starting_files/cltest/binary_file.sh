#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create binary file
create_binary_file "binary.dat"

# Should handle binary data
$COMMAND -c 100 binary.dat > output.bin
[ $(wc -c < output.bin) -eq 100 ]
