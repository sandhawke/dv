#!/bin/bash
# Test handling of Unicode input

source "$PROJECT_ROOT/cltest/_common.sh"

# Test string with various Unicode characters
unicode_text="Hello 世界 θ π 🌍"

echo "$unicode_text" | $COMMAND unicode.txt > stdout.txt

# Verify content
assert_file_content "unicode.txt" "$unicode_text"
assert_file_content "stdout.txt" "$unicode_text"
