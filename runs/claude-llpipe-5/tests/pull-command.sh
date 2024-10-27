#!/bin/bash
source tests/_common.sh

# Create test config dir
export LLPIPE_CONFIG="test_config"
rm -rf "$LLPIPE_CONFIG"
mkdir -p "$LLPIPE_CONFIG/history"

# Create a conversation
create_mock_llm "Specific response to pull"
echo "Test prompt" | $PROGRAM new > /dev/null

# Test pull command
$PROGRAM pull 1 > output.txt

# Check output
if ! grep -q "Specific response to pull" output.txt; then
  echo "ERROR: Expected response not found in pulled output"
  exit 1
fi

# Cleanup
cleanup_mock_llm
rm -rf "$LLPIPE_CONFIG" output.txt

echo "Test passed"
exit 0
