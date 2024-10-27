#!/bin/bash
source tests/_common.sh

# Setup mock LLM that simulates rate limit then success
cat > mock_llm.sh << 'EOF'
#!/bin/bash
if [ ! -f .tried_once ]; then
  touch .tried_once
  echo "Rate limit exceeded" >&2
  exit 1
fi
echo "Success after rate limit"
EOF
chmod +x mock_llm.sh
export LLPIPE_INNER="./mock_llm.sh"

# Create test config dir
export LLPIPE_CONFIG="test_config"
rm -rf "$LLPIPE_CONFIG"
mkdir -p "$LLPIPE_CONFIG/history"

# Test rate limit handling
echo "Test prompt" | $PROGRAM new > output.txt 2>error.txt

# Check output
if ! grep -q "Success after rate limit" output.txt; then
  echo "ERROR: Expected success response not found"
  exit 1
fi

if ! grep -q "Rate limit reached" error.txt; then
  echo "ERROR: Rate limit warning not found"
  exit 1
fi

# Cleanup
cleanup_mock_llm
rm -rf "$LLPIPE_CONFIG" output.txt error.txt .tried_once

echo "Test passed"
exit 0
