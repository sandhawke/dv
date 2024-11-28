# Common functions for test scripts

create_test_file() {
    cat > "$1"
}

assert_files_equal() {
    if ! cmp -s "$1" "$2"; then
        echo "Files $1 and $2 differ"
        echo "Expected ($1):"
        cat "$1"
        echo "Got ($2):"
        cat "$2"
        return 1
    fi
}
