# Common setup and helper functions for tests
create_test_file() {
    local filename="$1"
    shift
    printf "%s\n" "$@" > "$filename"
}

create_binary_file() {
    dd if=/dev/urandom of="$1" bs=1024 count=1 2>/dev/null
}
