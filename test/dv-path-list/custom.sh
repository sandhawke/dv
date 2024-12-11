#!/bin/bash

COMMAND=dv-path-list

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
        return 1
    fi
}

# Set up test files
mkdir -p src/foo docs test
touch src/test.txt src/test.tmp src/foo/bar.txt
touch docs/readme.md docs/readme.md~
touch test/.env.local test/.env.test
touch a.txt a.txt~

# Test 1: Basic ignore pattern
echo "*~" > .gitignore
result=$($COMMAND | grep -c "~$")
expect "Ignores backup files" "0" "$result"

# Test 2: Complex ignore pattern
cat > .gitignore << EOF
*.tmp
test/
.env*
EOF
result=$($COMMAND | grep -v "^test/" | grep -v "\.tmp$" | grep -v "\.env" | wc -l)
expected=$(find . -type f | grep -v "^./test/" | grep -v "\.tmp$" | grep -v "\.env" | wc -l)
expect "Complex ignore patterns work" "$expected" "$result"

# Test 3: Include pattern
result=$($COMMAND --include="*.txt" | wc -l)
expected=$(find . -name "*.txt" -type f | wc -l)
expect "Include pattern works" "$expected" "$result"

# Test 4: Multiple include patterns
result=$($COMMAND --include="*.txt" --include="*.md" | wc -l)
expected=$(find . -type f \( -name "*.txt" -o -name "*.md" \) | wc -l)
expect "Multiple include patterns work" "$expected" "$result"

# Test 5: Include and ignore together
echo "*.tmp" > .gitignore
result=$($COMMAND --include="src/*.txt" | wc -l)
expected=$(find src -name "*.txt" -type f | wc -l)
expect "Include and ignore together work" "$expected" "$result"

# Test 6: Directory argument
result=$($COMMAND src | wc -l)
expected=$(find src -type f | wc -l)
expect "Directory argument works" "$expected" "$result"

# Test 7: Multiple directory arguments
result=$($COMMAND src docs | wc -l)
expected=$(find src docs -type f | wc -l)
expect "Multiple directory arguments work" "$expected" "$result"

# Test 8: Nested ignore patterns
mkdir -p a/b/c
touch a/b/c/test.txt
echo "**/c/**" > .gitignore
result=$($COMMAND | grep -c "a/b/c/")
expect "Nested ignore patterns work" "0" "$result"

echo "All tests completed"
