#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create file with IEEE 754 floating point values
printf '\x00\x00\x80\x3f' > float.bin  # 1.0 in 32-bit float
printf '\x00\x00\x00\x40' >> float.bin # 2.0 in 32-bit float

# Test decimal format with raw bytes (not interpreting as floats)
output=$($COMMAND -d float.bin)
expected="0000000     0 16256     0 16384
0000010"

assert_output "$expected" "$output"
