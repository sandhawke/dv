# Ignore and Unignore Pattern Usage in packmime

This document explains how to use packmime's file filtering capabilities through `--ignore`, `--unignore`, and `--use-ignore-file` options.

## Pattern Syntax

Patterns follow .gitignore syntax:

- `*` matches any sequence of characters except `/`
- `**` matches zero or more directory levels
- `?` matches any single character except `/`
- `[abc]` matches any character in the brackets
- `[a-z]` matches any character in the range
- Leading `/` matches from project root
- Trailing `/` matches only directories
- `!` at start negates the pattern (in ignore files only)

## Basic Usage

### Simple Patterns

```console
# Ignore all .txt files
$ packmime --ignore="*.txt" directory/

# Ignore specific file
$ packmime --ignore="data.json" directory/

# Ignore specific directory
$ packmime --ignore="temp/" directory/
```

### Using Multiple Patterns

```console
# Ignore .txt files but keep important.txt
$ packmime --ignore="*.txt" --unignore="important.txt" directory/

# Complex combinations
$ packmime \
    --ignore="*.log" \
    --ignore="temp/" \
    --unignore="temp/keep.log" \
    directory/
```

### Pattern Precedence

1. Explicit command-line arguments always included
2. `--unignore` patterns
3. `--ignore` patterns and patterns from ignore files

If a path matches both ignore and unignore patterns, unignore wins.

## Using Ignore Files

```console
# Create an ignore file
$ cat > my-ignore
*.log
temp/
!temp/keep.log

# Use the ignore file
$ packmime --use-ignore-file=my-ignore directory/
```

## Advanced Patterns

### Directory-Specific

```console
# Ignore all 'test' directories
$ packmime --ignore="**/test/" project/

# Ignore specific subdirectory
$ packmime --ignore="src/test/" project/
```

### Nested Patterns

```console
# Ignore nested directories except specific files
$ packmime \
    --ignore="**/.cache/**" \
    --unignore="**/.cache/important.dat" \
    project/
```

### Pattern Conflicts

Example of pattern conflict resolution:

```console
# These patterns conflict
$ packmime \
    --ignore="**/*.log" \
    --ignore="logs/**" \
    --unignore="logs/important.log" \
    project/

# Result:
# - Most logs/*.log files are ignored
# - logs/important.log is included (unignore wins)
# - All other files in logs/ are ignored
```

## Tricky Cases

### Case 1: Nested Unignore

```console
$ packmime \
    --ignore="test/**" \
    --unignore="test/**/spec.js" \
    project/

# Results:
# - Ignores everything under test/
# - But includes any spec.js files at any depth
```

### Case 2: Partial Path Matching

```console
$ packmime \
    --ignore="build" \
    --ignore="build/**" \
    project/

# Results:
# - Ignores file/directory named 'build'
# - Also ignores everything under build/
# - Does not ignore 'rebuilding' or 'build.txt'
```

### Case 3: Directory vs File Patterns

```console
$ packmime \
    --ignore="logs/" \
    --ignore="*.log" \
    --unignore="app.log" \
    project/

# Results:
# - Ignores the logs directory and its contents
# - Ignores .log files anywhere
# - Includes app.log (but not if it's in logs/)
```

## Common Patterns

```console
# Development files
--ignore="**/.git/"
--ignore="**/node_modules/"
--ignore="**/.env"

# Build artifacts
--ignore="**/dist/"
--ignore="**/build/"
--ignore="**/*.min.js"

# Temporary files
--ignore="**/.DS_Store"
--ignore="**/thumbs.db"
--ignore="**/*.tmp"
```

## Error Handling

- Invalid patterns print warning to stderr
- Directory access errors don't stop processing
- Processing continues even if all files are ignored

## Performance Note

Ignore patterns are evaluated for every file encountered. For best performance:

1. Use specific patterns over broad ones
2. Limit the depth of `**` patterns
3. Put most common patterns first
