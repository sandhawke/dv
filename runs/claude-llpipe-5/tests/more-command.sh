#!/bin/bash
source tests/_common.sh

# Setup mock LLM
create_mock_llm "Follow-up response"

# Create test config dir
export LLPIPE_CONFIG="test_config"
rm -rf "$LLPIPE_CONFIG"
mkdir -p "$LLPIPE_CONFIG/history"

# Create initial conversation
echo "Initial prompt" | $PROGRAM new > /dev/null

# Test more command
echo "Follow-up prompt" | $PROGRAM more > output.txt

# Check output
if ! grep -q "Follow-up response" output.txt; then
  echo "ERROR: Expected response not found in output"
  exit 1
fi

# Check history files
if [ ! -f "$LLPIPE_CONFIG/history/2/messages.json" ]; then
  echo "ERROR: Messages file not created for second interaction"
  exit 1
fi

# Cleanup
cleanup_mock_llm
rm -rf "$LLPIPE_CONFIG" output.txt

echo "Test passed"
exit 0
