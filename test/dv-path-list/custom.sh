#!/bin/bash

# Create a temporary directory for tests
test_dir=$(mktemp -d)
cd "$test_dir" || exit 1

# Clean up on exit
trap 'rm -rf "$test_dir"' EXIT

# Test helper function
expect() {
    local name=$1
    local expected=$2
    local actual=$3
    
    if [ "$expected" = "$actual" ]; then
        echo "✓ $name"
    else
        echo "✗ $name"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        echo "  Files present:"
        find . -type f | sort
        return 1
    fi
}

# Create test directory structure
mkdir -p src/foo docs test
touch src/test.txt src/test.tmp src/foo/bar.txt
touch docs/readme.md docs/readme.md~
touch test/.env.local test/.env.test
touch a.txt a.txt~

echo "Test files created:"
find . -type f | sort

# Test 1: Basic ignore pattern
echo "*~" > .gitignore
echo "Running test 1 with DEBUG=1..."
result=$(DEBUG=1 dv-path-list 2>test1.debug | grep -c "~$" || true)
expect "Ignores backup files" "0" "$result"
echo "Debug output for test 1:"
cat test1.debug

# Test 2: Complex ignore pattern
cat > .gitignore << EOF
*.tmp
test/
.env*
EOF
result=$(dv-path-list | grep -v "^test/" | grep -v "\.tmp$" | grep -v "\.env" | wc -l)
expected=$(find . -type f | grep -v "^./test/" | grep -v "\.tmp$" | grep -v "\.env" | wc -l)
expect "Complex ignore patterns work" "$expected" "$result"

# Test 3: Include pattern
echo "Running test 3 with DEBUG=1..."
result=$(DEBUG=1 dv-path-list --include="*.txt" 2>test3.debug | wc -l)
expected=$(find . -name "*.txt" -type f | wc -l)
expect "Include pattern works" "$expected" "$result"
echo "Debug output for test 3:"
cat test3.debug

# Test 4: Multiple include patterns
result=$(dv-path-list --include="*.txt" --include="*.md" | wc -l)
expected=$(find . -type f \( -name "*.txt" -o -name "*.md" \) | wc -l)
expect "Multiple include patterns work" "$expected" "$result"

# Test 5: Include and ignore together
echo "*.tmp" > .gitignore
echo "Running test 5 with DEBUG=1..."
result=$(DEBUG=1 dv-path-list --include="src/*.txt" 2>test5.debug | wc -l)
expected=$(find src -name "*.txt" -type f | wc -l)
expect "Include and ignore together work" "$expected" "$result"
echo "Debug output for test 5:"
cat test5.debug

# Test 6: Directory argument
result=$(dv-path-list src | wc -l)
expected=$(find src -type f | wc -l)
expect "Directory argument works" "$expected" "$result"

# Test 7: Multiple directory arguments
result=$(dv-path-list src docs | wc -l)
expected=$(find src docs -type f | wc -l)
expect "Multiple directory arguments work" "$expected" "$result"

# Test 8: Nested ignore patterns
mkdir -p a/b/c
touch a/b/c/test.txt
echo "**/c/**" > .gitignore
result=$(dv-path-list | grep -c "a/b/c/" || true)
expect "Nested ignore patterns work" "0" "$result"

echo "All tests completed"
