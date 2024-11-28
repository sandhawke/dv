# Common test utilities and setup
assert_file_content() {
    local file="$1"
    local expected="$2"
    local actual
    actual=$(cat "$file")
    if [ "$actual" != "$expected" ]; then
        echo "Expected content: $expected"
        echo "Actual content: $actual"
        return 1
    fi
    return 0
}

assert_file_exists() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "Expected file $file to exist"
        return 1
    fi
    return 0
}

assert_exit_code() {
    local expected=$1
    local actual=$2
    if [ "$actual" != "$expected" ]; then
        echo "Expected exit code $expected, got $actual"
        return 1
    fi
    return 0
}

assert_stdout_contains() {
    local pattern="$1"
    local file="$2"
    if ! grep -q "$pattern" "$file"; then
        echo "Expected stdout to contain: $pattern"
        echo "Actual stdout:"
        cat "$file"
        return 1
    fi
    return 0
}
