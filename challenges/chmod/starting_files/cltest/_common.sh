# Create test files with known permissions
setup_test_files() {
    echo "test content" > regular_file
    chmod 644 regular_file

    mkdir test_dir
    echo "test content" > test_dir/file1
    echo "test content" > test_dir/file2
    mkdir test_dir/subdir
    echo "test content" > test_dir/subdir/file3
}

# Helper to check if permissions match expected octal mode
check_perms() {
    local file="$1"
    local expected="$2"
    local actual=$(stat -c '%a' "$file")
    [ "$actual" = "$expected" ]
}
