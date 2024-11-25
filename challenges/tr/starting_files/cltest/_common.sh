# Common test utilities and setup

# Create a file with specific content
make_file() {
    local filename="$1"
    cat > "$filename"
}

# Verify two files have identical content
assert_files_equal() {
    local file1="$1"
    local file2="$2"
    if ! cmp -s "$file1" "$file2"; then
        echo "Files differ: $file1 vs $file2" >&2
        echo "Expected: $(cat "$file1")" >&2
        echo "Got: $(cat "$file2")" >&2
        return 1
    fi
}

# Check if command output matches expected string
assert_output() {
    local expected="$1"
    local output="$2"
    if [ "$expected" != "$output" ]; then
        echo "Output mismatch" >&2
        echo "Expected: '$expected'" >&2
        echo "Got: '$output'" >&2
        return 1
    fi
}
