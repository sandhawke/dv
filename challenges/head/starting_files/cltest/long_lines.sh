#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create a file with very long lines
printf '%16000s' "X" > longline.txt
echo >> longline.txt
printf '%16000s' "Y" >> longline.txt
echo >> longline.txt

# Test handling of long lines
$COMMAND -n 1 longline.txt > output.txt

# Check that the line wasn't truncated
[ $(wc -c < output.txt) -gt 16000 ] || exit 1

# Test with byte count on long line
$COMMAND -c 100 longline.txt > output2.txt
[ $(wc -c < output2.txt) -eq 100 ] || exit 1
