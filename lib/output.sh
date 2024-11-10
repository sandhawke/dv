#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to write colored text to stderr
error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" >&2
}

info() {
    echo -e "${BLUE}[INFO]${NC} $*" >&2
}

success() {
    echo -e "${GREEN}$*${NC}" >&2
}
