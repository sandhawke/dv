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
MEDRED='\033[0;31m'
GREEN='\033[1;92m'   
YELLOW='\033[1;93m'  
BLUE='\033[1;96m'     # really cyan
GRAY='\033[90m'       
NC='\033[0m'          # No Color

status_file="${DV_STATUS_FILE:-}"
write () {
    if [ -n "${DV_LOGFILE:-}" ]; then
        mkdir -p "$(dirname "$DV_LOGFILE")"
        echo "$(date -u -Ins)" "$@" >> "$DV_LOGFILE"
    fi
    if [[ -n "$status_file" && -f "$status_file" ]]; then
        edits=$(git log --oneline | wc -l)
        # would be nice to have a USD LLM charge total to include
        echo "@$edits" "$@" '--' "$PWD" > "$status_file"
    fi
}

log_error() {
    write "$cmd" ERROR "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${RED}$*${NC}" >&2
}

log_warning() {
    write "$cmd" WARNING "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${YELLOW}$*${NC}" >&2
}

log_warn() {
    log_warning "$@"
}

log_info() {
    write "$cmd" INFO "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${BLUE}$*${NC}" >&2
}

log_success() {
    write "$cmd" SUCCESS "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${GREEN}$*${NC}" >&2
}

log_debug() {
    # default on/off ???
    write "$cmd" DEBUG "$@"
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

mkdir_for_files() {
    for file in "$@"; do
        dir="$(dirname "$file")"
        mkdir -p "$dir"
    done
}

sanitize_id() {
    echo "$1" | sed -e 's/[^[:alnum:]_]/_/g' -e 's/^[^[:alpha:]]/_%&/'
}
