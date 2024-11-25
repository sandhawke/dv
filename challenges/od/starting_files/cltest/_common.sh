# Creates a test file with predictable binary content
# Creates exactly 16 bytes, no more, no less
create_test_file() {
    # Truncate or create the file
    : > "$1"
    # Create exactly 16 bytes of sequential data
    for i in {0..15}; do
        printf "\\$(printf '%03o' $i)" >> "$1"
    done
}

# Creates a test file with ASCII text
create_text_file() {
    printf "Hello, World!" > "$1"  # No newline
}

# Verify two files are identical
assert_files_equal() {
    if ! cmp -s "$1" "$2"; then
        echo "Files $1 and $2 differ"
        return 1
    fi
}

# Assert command output equals expected string
assert_output() {
    local expected="$1"
    local output="$2"
    if [ "$expected" != "$output" ]; then
        echo "Expected: $expected"
        echo "Got: $output"
        echo "Lengths - Expected: ${#expected}, Got: ${#output}"
        return 1
    fi
}
