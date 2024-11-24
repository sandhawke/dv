set -euo pipefail
trap 'echo "$0": non-zero exit value "$?" at lineno ${LINENO} running "${BASH_COMMAND}"' ERR

cmd=$(basename $0)
# DV_COMMAND is the outer-most command, which is good to log, unless
# something inside overrides it. Generally we'd like dv-prompt-* commands
# to be listed here, since this is used in git log.
#
# So just 'export DV_COMMAND=foo' in a script if you want to manually
# set this.
: "${DV_COMMAND:=$cmd}"
export DV_COMMAND

commit_message_file=_from_developer/commit_message

# ANSI color codes - updated for better visibility on dark backgrounds
RED='\033[1;101m'    
GREEN='\033[1;92m'   
YELLOW='\033[1;93m'  
BLUE='\033[1;96m'     # really cyan
GRAY='\033[90m'       
NC='\033[0m'          # No Color

write () {
    if [ -n "${DV_LOGFILE:-}" ]; then
        mkdir -p "$(dirname "$DV_LOGFILE")"
        echo "$(date -u -Ins)" "$@" >> "$DV_LOGFILE"
    fi
}

log_error() {
    write "$cmd ERROR $*"
    test -n "${DV_SILENT:-}" && return
    echo -e "${RED}$*${NC}" >&2
}

log_warning() {
    write "$cmd WARNING $*"
    test -n "${DV_SILENT:-}" && return
    echo -e "${YELLOW}$*${NC}" >&2
}

log_info() {
    write "$cmd INFO $*"
    test -n "${DV_SILENT:-}" && return
    echo -e "${BLUE}$*${NC}" >&2
}

log_success() {
    write "$cmd SUCCESS $*"
    test -n "${DV_SILENT:-}" && return
    echo -e "${GREEN}$*${NC}" >&2
}

log_debug() {
    # default on/off ???
    write "$cmd DEBUG $*"
    test -n "${DV_SILENT:-}" && return
    echo -e "${GRAY}[DEBUG] $*${NC}" >&2
}

# Legacy functions with deprecation warnings
error() {
    log_warning "The 'error' function is deprecated. Please use 'log_error' instead."
    log_error "$@"
}

warning() {
    log_warning "The 'warning' function is deprecated. Please use 'log_warning' instead."
    log_warning "$@"
}

info() {
    log_warning "The 'info' function is deprecated. Please use 'log_info' instead."
    log_info "$@"
}

success() {
    log_warning "The 'success' function is deprecated. Please use 'log_success' instead."
    log_success "$@"
}

new_name() {
    local dir="${1:-$PWD}"      # Default to current directory if not specified
    local slug="${2:-}"        # Optional slug prefix
    local pattern
    local highest=0
    
    mkdir -p "$dir"
    
    # Set up the pattern based on whether we have a slug
    if [ -n "$slug" ]; then
        pattern="^${slug}-([0-9]+)$"
    else
        pattern="^([0-9]+)$"
    fi
    
    # Find the highest number
    while IFS= read -r entry; do
        if [[ -e "$dir/$entry" ]]; then  # Check if file/dir exists
            if [ -n "$slug" ]; then
                if [[ "$entry" =~ $pattern ]]; then
                    num="${BASH_REMATCH[1]}"
                    if [ "$num" -gt "$highest" ]; then
                        highest=$num
                    fi
                fi
            else
                if [[ "$entry" =~ $pattern ]]; then
                    num="${BASH_REMATCH[1]}"
                    if [ "$num" -gt "$highest" ]; then
                        highest=$num
                    fi
                fi
            fi
        fi
    done < <(ls -A "$dir")
    
    # Generate the next number
    next=$((highest + 1))
    
    # Create the new name
    if [ -n "$slug" ]; then
        echo "$dir/$slug-$next"
    else
        echo "$dir/$next"
    fi
}
