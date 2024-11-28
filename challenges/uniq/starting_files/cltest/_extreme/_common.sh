# Create a test file with the given content
create_test_file() {
    local filename="$1"
    cat > "$filename"
}

# Compare two files and return 0 if they are identical
compare_files() {
    local file1="$1"
    local file2="$2"
    cmp -s "$file1" "$file2"
}

# Create a file with a specific number of identical lines
create_repeated_lines() {
    local filename="$1"
    local content="$2"
    local count="$3"
    yes "$content" | head -n "$count" > "$filename"
}

# Create a binary file with the given hex content
create_binary_file() {
    local filename="$1"
    local hexdata="$2"
    echo "$hexdata" | xxd -r -p > "$filename"
}

# Create a file with specific line endings
create_file_with_endings() {
    local filename="$1"
    local ending="$2"  # "unix", "dos", or "mac"
    case "$ending" in
        "unix") tr -d '\r' > "$filename" ;;
        "dos")  sed 's/$/\r/' > "$filename" ;;
        "mac")  tr '\n' '\r' > "$filename" ;;
    esac
}

# Generate a large file with repeated content
create_large_file() {
    local filename="$1"
    local size_mb="$2"
    dd if=/dev/zero bs=1M count="$size_mb" 2>/dev/null | tr '\0' '\n' > "$filename"
}
