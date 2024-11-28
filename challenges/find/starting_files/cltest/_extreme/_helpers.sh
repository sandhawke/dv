# Helper functions for find tests
setup_test_files() {
    mkdir -p dir1/subdir1 dir2/subdir2
    touch dir1/file1.txt dir1/file2.txt
    touch dir1/subdir1/file3.txt
    touch dir2/file4.txt
    touch dir2/subdir2/file5.txt
    echo "content" > dir1/file1.txt
    dd if=/dev/zero of=dir1/largefile bs=1024 count=100 2>/dev/null
    rm -f symlink1  # Remove symlink if it exists
    ln -s dir1/file1.txt symlink1
    chmod 755 dir1 dir2 dir1/subdir1 dir2/subdir2
    chmod 644 dir1/file1.txt dir1/file2.txt dir1/subdir1/file3.txt
    chmod 444 dir2/file4.txt

    # Create files with specific timestamps for time-based tests
    touch -d "2 days ago" dir1/oldfile.txt
    touch -d "1 hour ago" dir1/newfile.txt
}

count_results() {
    wc -l | tr -d ' '
}

assert_equals() {
    if [ "$1" != "$2" ]; then
        echo "Assertion failed: Expected '$1', got '$2'" >&2
        return 1
    fi
    return 0
}
