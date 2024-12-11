# dv-path-list - File Path Listing Utility

## Purpose
Lists files in a directory tree, with configurable filtering based on file patterns. Combines directory traversal with gitignore-style pattern matching.

## Basic Operation
1. Without any arguments, lists all files in the current directory tree
2. Automatically excludes files matching patterns in .gitignore and .dv/nopack.txt if these files exist for this tree (.dv is found use "$(dv-project-dir)/.dv")

## Arguments
- Directories/files: Lists only files under specified paths
- `--include=PATTERN`: Only include files matching the pattern
- `--ignore=PATTERN`: Exclude files matching the pattern
- Multiple arguments of each type are allowed

## Pattern Matching Rules
Follows .gitignore pattern syntax:
1. `*` matches any text except `/` (e.g., `*.txt` matches `foo.txt` but not `dir/foo.txt`)
2. `**` matches any text including `/` (e.g., `**.txt` matches both `foo.txt` and `dir/foo.txt`)
3. Pattern without `/` matches anywhere in path (e.g., `*.txt` matches `a.txt`, `dir/b.txt`)
4. Pattern with leading `/` anchors to root (e.g., `/foo.txt` only matches `foo.txt` at root)
5. Pattern with trailing `/` matches directories and their contents (e.g., `test/` matches all files under test/)
6. Pattern with internal `/` matches relative to root (e.g., `doc/txt` matches `doc/txt`)

## Processing Order
1. Start with base files (from directory arguments or current directory)
2. Apply ignore patterns (from .gitignore, .dv/nopack.txt, and --ignore arguments)
3. Apply include patterns (if any --include arguments)
4. Output remaining files, sorted alphabetically

## Output Format
- One file path per line
- Paths are relative to current directory
- No leading `./` in paths
- Output is sorted alphabetically

## Examples
```bash
# List all files in current directory tree (except ignored)
dv-path-list

# List only .txt files under src/
dv-path-list src/ --include=*.txt

# List files under docs/ and test/, excluding .tmp files
dv-path-list docs/ test/ --ignore=*.tmp

# Combine includes and ignores
dv-path-list --include=*.md --ignore=draft/ --ignore=*.tmp
```

