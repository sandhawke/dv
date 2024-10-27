#!/bin/bash
source tests/_common.sh

# Setup mock LLM that fails
cat > mock_llm.sh << 'EOF'
#!/bin/bash
echo "Error message" >&2
exit 1
EOF
chmod +x mock_llm.sh
export LLPIPE_INNER="./mock_llm.sh"

# Create test config dir
export LLPIPE_CONFIG="test_config"
rm -rf "$LLPIPE_CONFIG"
mkdir -p "$LLPIPE_CONFIG/history"

# Test error handling
if echo "Test prompt" | $PROGRAM new > output.txt 2>error.txt; then
  echo "ERROR: Command should have failed"
  exit 1
fi

# Check error file was created
if [ ! -f "$LLPIPE_CONFIG/history/1/error.json" ]; then
  echo "ERROR: Error file not created"
  exit 1
fi

# Cleanup
cleanup_mock_llm
rm -rf "$LLPIPE_CONFIG" output.txt error.txt

echo "Test passed"
exit 0
