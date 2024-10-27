#!/bin/bash
source tests/_common.sh

# Setup mock LLM
create_mock_llm "This is a test response"

# Create test config dir
export LLPIPE_CONFIG="test_config"
rm -rf "$LLPIPE_CONFIG"
mkdir -p "$LLPIPE_CONFIG/history"

# Test basic new command
echo "Test prompt" | $PROGRAM new > output.txt

# Check output
if ! grep -q "This is a test response" output.txt; then
  echo "ERROR: Expected response not found in output"
  exit 1
fi

# Check history files
if [ ! -f "$LLPIPE_CONFIG/history/1/messages.json" ]; then
  echo "ERROR: Messages file not created"
  exit 1
fi

if [ ! -f "$LLPIPE_CONFIG/history/1/start.json" ]; then
  echo "ERROR: Start file not created"
  exit 1
fi

if [ ! -f "$LLPIPE_CONFIG/history/1/meta.json" ]; then
  echo "ERROR: Meta file not created"
  exit 1
fi

# Cleanup
cleanup_mock_llm
rm -rf "$LLPIPE_CONFIG" output.txt

echo "Test passed"
exit 0
