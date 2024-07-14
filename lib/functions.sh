
# Function to start the timer
# from claude https://claude.ai/chat/666b5bbd-2f26-4114-b454-a4ff1b30cde2
start_timing() {
    G_START_TIME=$(date +%s)
    # echo "Timer started."
}

# Function to end the timer and print stats
end_timing() {
    local end_time=$(date +%s)
    local elapsed=$((end_time - G_START_TIME))
    
    echo "Seconds elapsed: $elapsed"
    
    # More detailed breakdown
    local days=$((elapsed / 86400))
    local hours=$(( (elapsed % 86400) / 3600 ))
    local minutes=$(( (elapsed % 3600) / 60 ))
    local seconds=$((elapsed % 60))
    
    echo "Time elapsed: $days days, $hours hours, $minutes minutes, $seconds seconds"
}
