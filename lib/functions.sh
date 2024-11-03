
# Function to start the timer
# from claude https://claude.ai/chat/666b5bbd-2f26-4114-b454-a4ff1b30cde2
start_timing() {
    G_START_TIME=$(date +%s)
    # echo "Timer started."
}

# Function to end the timer and print stats
stop_timing() {
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

PROMPTS=$script_dir/../prompts
START_DIR="$PWD"
LATEST="$START_DIR/latest"
mkdir -p "$LATEST"

make_output_dir() {
    local prev
    prev=''
    for i in {1..9999}; do
        dir=$(printf "out.%04d" $i)
        if mkdir "$dir" &>/dev/null; then
            if [ -n "$prev" ]; then
                # this isn't really smart enough.  we might not want direct prev -- and ONLY ON MORE.
                echo "**** Copying '${prev}' as baseline" >&2
                # printf '<%s> ' BGCOPY rsync -a "$prev"/ "$dir" ENDBG >&2
                rsync -a "$prev"/ "$dir" >&2
            else
                echo 'No previous output directory'>&2
            fi
            echo "$dir"
            return
        fi
        prev="$dir"
        # echo PREVIOUS $prev >&2
    done
    echo "Hit 10k directories. Giving up." >&2
    exit 1
}

move_to_output_dir() {
    cd "$START_DIR"
    REAL_INPUT_DIR=${INPUT_DIR-input}
    if [ -d "$REAL_INPUT_DIR" ]; then
        OUTPUT_DIR=$(make_output_dir)
        echo "Using output directory '$OUTPUT_DIR'"
        printf '<%s> ' rsync -a "$REAL_INPUT_DIR"/ "$OUTPUT_DIR"
        rsync -a "$REAL_INPUT_DIR"/ "$OUTPUT_DIR"
        cd "$OUTPUT_DIR"
        ABS_OUTPUT_DIR=$PWD
    else
        echo "There is no '$REAL_INPUT_DIR' directory here. Stopping."
        echo "(Maybe in the future we can clobber files safely in git.)"
        exit 1
    fi
}

save() {
    echo Wrote to "$ABS_OUTPUT_DIR"
    echo Write to "$LATEST"
    mkdir -p "$LATEST"
    # trailing slash is vital, otherwise we end up down a level
    printf '<%s> ' rsync -av --delete "$ABS_OUTPUT_DIR"/ "$LATEST"
    rsync -av --delete "$ABS_OUTPUT_DIR"/ "$LATEST"
    cd "$START_DIR"
    if [ -n "$SAVE_LATEST_AS" ]; then
        rsync -a --delete "$ABS_OUTPUT_DIR"/ "$SAVE_LATEST_AS"
        echo Write to "$SAVE_LATEST_AS"
    fi
}

new_chat() {
    local user_prompt
    user_prompt="$1"

    start_timing
    move_to_output_dir

    out=$(mktemp --suffix=.mime)
    plainpack user_prompt="$user_prompt" . | tee /tmp/dv-sent.mime | llpipe new $PROMPTS/basic.md | tee $out
    echo $out >> _log
    plainpack -u -f $out
    stop_timing
    save
}


more_chat() {
    local user_prompt
    local more_files
    user_prompt="$1"
    more_files="${2:-}"

    start_timing
    
    # need to package up any $more_files in the CWD before we move, since
    # the user may have given this argument.
    infile=$(mktemp --suffix=.in.mime)
    plainpack user_prompt="$user_prompt" ${more_files:+"$more_files"} > $infile
    move_to_output_dir

    out=$(mktemp --suffix=.mime)
    llpipe more < $infile | tee $out
    echo $out >> _log
    echo 'output directory before unpacking'
    find . -print
    plainpack -u -f $out
    stop_timing
    save
}
