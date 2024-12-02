#!/bin/bash
# Test -i/--ignore-interrupts option

source "$PROJECT_ROOT/cltest/_common.sh"

# Create a named pipe for controlled input
mkfifo input_pipe

# Start tee in background with ignore interrupts
$COMMAND -i output.txt < input_pipe > /dev/null &
pid=$!

# Small delay to ensure process is running
sleep 0.1

# Verify process started successfully
if ! kill -0 $pid 2>/dev/null; then
    echo "Failed to start tee process"
    rm input_pipe
    exit 1
fi

# Send SIGINT
kill -INT $pid

# Small delay to allow signal processing
sleep 0.1

# Verify process is still running
if ! kill -0 $pid 2>/dev/null; then
    echo "Process terminated despite -i flag"
    rm input_pipe
    exit 1
fi

# Send test data and close pipe
echo "test data" > input_pipe

# Wait for process to finish
wait $pid

# Clean up
rm input_pipe

# Verify output was written
assert_file_content "output.txt" "test data"
