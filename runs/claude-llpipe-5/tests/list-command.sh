#!/bin/bash
source tests/_common.sh

# Create test config dir
export LLPIPE_CONFIG="test_config"
rm -rf "$LLPIPE_CONFIG"
mkdir -p "$LLPIPE_CONFIG/history"

# Create some conversations
create_mock_llm "First response"
echo "First prompt" | $PROGRAM new > /dev/null

create_mock_llm "Second response"
echo "Second prompt" | $PROGRAM new > /dev/null

# Test list command
$PROGRAM list > output.txt

# Check output
if ! grep -q "First prompt" output.txt; then
  echo "ERROR: First prompt not found in list output"
  exit 1
fi

if ! grep -q "Second prompt" output.txt; then
  echo "ERROR: Second prompt not found in list output"
  exit 1
fi

# Cleanup
cleanup_mock_llm
rm -rf "$LLPIPE_CONFIG" output.txt

echo "Test passed"
exit 0
