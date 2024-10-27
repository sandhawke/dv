#!/bin/bash
source tests/_common.sh

# Setup mock LLM
create_mock_llm "Response after specific history"

# Create test config dir
export LLPIPE_CONFIG="test_config"
rm -rf "$LLPIPE_CONFIG"
mkdir -p "$LLPIPE_CONFIG/history"

# Create initial conversations
echo "First prompt" | $PROGRAM new > /dev/null
echo "Second prompt" | $PROGRAM new > /dev/null

# Test after command
echo "Follow-up to first" | $PROGRAM after 1 > output.txt

# Check output
if ! grep -q "Response after specific history" output.txt; then
  echo "ERROR: Expected response not found in output"
  exit 1
fi

# Check history files
if [ ! -f "$LLPIPE_CONFIG/history/3/messages.json" ]; then
  echo "ERROR: Messages file not created for third interaction"
  exit 1
fi

# Cleanup
cleanup_mock_llm
rm -rf "$LLPIPE_CONFIG" output.txt

echo "Test passed"
exit 0
