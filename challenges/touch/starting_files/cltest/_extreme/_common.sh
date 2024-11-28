# Common functions for touch command tests

# Create a file with specific timestamps for testing
create_test_file() {
    local filename="$1"
    echo "test content" > "$filename"
    # Set both timestamps to 2020-01-01 00:00:00 UTC
    TZ=UTC touch -t 202001010000.00 "$filename"
}

# Parse and return timestamp in seconds since epoch
get_file_mtime() {
    stat -c %Y "$1"
}

get_file_atime() {
    stat -c %X "$1"
}

# Check if two timestamps are equal
timestamps_equal() {
    [ "$1" -eq "$2" ]
}
