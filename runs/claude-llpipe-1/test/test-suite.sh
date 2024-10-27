#!/bin/bash
set -e
set -x  # Add debug output

# Setup test environment
TEST_DIR=$(mktemp -d)
mkdir -p $TEST_DIR/.llpipe/history
export LLPIPE_CONFIG="$TEST_DIR/.llpipe"

# Mock LLM response script
cat > $TEST_DIR/mock_llm.js <<'EOL'
#!/usr/bin/env node

let input = '';
process.stdin.on('data', (chunk) => {
  input += chunk;
});

process.stdin.on('end', () => {
  try {
    const data = JSON.parse(input);
    const lastMessage = data.messages[data.messages.length - 1].content;
    
    const response = {
      content: [
        {
          text: lastMessage.includes('color is the sky') ? 'Blue.' : 'This is a mock response.'
        }
      ]
    };
    
    process.stdout.write(response.content[0].text);
  } catch (error) {
    console.error('Mock LLM error:', error);
    process.exit(1);
  }
});
EOL

chmod +x $TEST_DIR/mock_llm.js

# Helper functions
cleanup() {
  rm -rf "$TEST_DIR"
}

assert_equals() {
  local expected="$1"
  local actual="$2"
  if [ "$expected" != "$actual" ]; then
    echo "Assert failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$actual'"
    exit 1
  fi
}

assert_file_exists() {
  if [ ! -f "$1" ]; then
    echo "Assert failed: File does not exist: $1"
    exit 1
  fi
}

assert_contains() {
  local file="$1"
  local pattern="$2"
  if ! grep -q "$pattern" "$file"; then
    echo "Assert failed: Pattern not found in file"
    echo "Pattern: $pattern"
    echo "File contents:"
    cat "$file"
    exit 1
  fi
}

trap cleanup EXIT

echo "Running test suite..."

# Test 1: Basic operation with --new
echo "Test 1: Basic new query"
export LLPIPE_INNER="$TEST_DIR/mock_llm.js"
result=$(echo "in a word, what color is the sky?" | ./llpipe.js --new)
assert_equals "Blue." "$result"
assert_file_exists "$LLPIPE_CONFIG/history/1/messages.json"
assert_contains "$LLPIPE_CONFIG/history/1/messages.json" "Blue"

# Test 2: Check history creation and files
echo "Test 2: History files check"
assert_file_exists "$LLPIPE_CONFIG/history/1/meta.json"

# Test 3: System prompt handling
echo "Test 3: System prompt"
echo "You are a helpful assistant." > "$LLPIPE_CONFIG/system-prompt.txt"
echo "test query" | ./llpipe.js --new
assert_contains "$LLPIPE_CONFIG/history/2/messages.json" "mock response"

# Test 4: History continuation
echo "Test 4: History continuation"
echo "continue previous" | ./llpipe.js --after 1
assert_file_exists "$LLPIPE_CONFIG/history/3/messages.json"
assert_contains "$LLPIPE_CONFIG/history/3/messages.json" "continue previous"

# Test 5: More option
echo "Test 5: More option"
echo "continue latest" | ./llpipe.js --more
assert_file_exists "$LLPIPE_CONFIG/history/4/messages.json"
assert_contains "$LLPIPE_CONFIG/history/4/messages.json" "continue latest"

# Test 6: List option
echo "Test 6: List option"
output=$(./llpipe.js --list)
echo "$output" | grep -q "1.*sky"

# Test 7: Pull option
echo "Test 7: Pull option"
result=$(./llpipe.js --pull 1)
assert_equals "Blue." "$result"

# Test 8: Missing API key
echo "Test 8: Missing API key"
unset LLPIPE_INNER
unset ANTHROPIC_API_KEY
unset OPENAI_API_KEY
if echo "test" | ./llpipe.js 2>&1 | grep -q "API key"; then
  echo "API key error detected correctly"
else
  echo "Failed to detect missing API key"
  exit 1
fi

echo "All tests passed successfully!"
