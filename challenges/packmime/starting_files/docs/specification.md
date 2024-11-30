# packmime - MIME Multipart File Packager

`packmime` combines files and form data into MIME multipart messages, with rich options for filtering, size limits, and output formatting.

## Synopsis

```
packmime [options] [terms]...
```

Where `terms` are files, directories, and/or key=value pairs.

## Input Processing

### Term Types

1. **Files**: Included as MIME attachments
2. **Directories**: Recursively traversed in lexicographic (codepoint) order
3. **key=value**: Included as form-data entries

### Directory Traversal

- Maximum depth: 32 levels
- Entries processed in codepoint order (e.g., "0" < "B" < "a")
- Symlinks handled per `--symlink-action` setting

## Output Format

### Basic Structure

```console
$ packmime file1.txt key1=value1
Content-Type: multipart/mixed; boundary="boundary-00"

--boundary-00
Content-Disposition: attachment; filename="file1.txt"
...file content...
--boundary-00
Content-Disposition: form-data; name="key1"
value1
--boundary-00--
```

### Path Handling

- Paths are relative to CWD
- Canonical form (resolved ".." and ".")
- Paths with quotes or non-space whitespace trigger warnings and are skipped

## Options

### Content Control

```
--ignore=PATTERN        Add gitignore-style pattern
--unignore=PATTERN     Pattern to override ignores
--use-ignore-file=FILE Read ignore patterns from file
```

### Size Limits

```
--max-file-bytes=N     Skip/handle files larger than N bytes
--max-file-tokens=N    Limit token count per file
--context=N            Total output token limit
```

### Output Formatting

```
--prefix=TEXT          Prepend text before MIME content
--suffix=TEXT          Append text after MIME content
--preserve             Include Content-Modified headers
--mime-types          Include Content-Type headers
--lf                  Use LF line endings
--cr                  Use CRLF line endings (default)
```

### Operation Modes

```
--on-file-too-large=[skip|truncate|replace|fail]
--symlink-action=[skip|follow|describe|auto]
--base64=FILE         Force base64 encoding for FILE
```

### Verbosity

```
--quiet, -q           Minimal output (--verbose=0)
--verbose=N          Verbosity level (0-4)
-v                   Level 2 verbosity
-vv                  Level 3 verbosity
-vvv                 Level 4 verbosity
```

### Other

```
--help               Show help text
--config=FILE        Use config file (default: .packmime-config.json)
```

## Examples

### Basic Usage

```console
$ packmime file1.txt dir1/ key1=value1
Content-Type: multipart/mixed; boundary="boundary-00"
...
$ echo $?
0
```

### Size Limits

```console
$ packmime --max-file-bytes=1000000 large-file.txt
Content-Type: multipart/mixed; boundary="boundary-00"
...
Content-Disposition: attachment; filename="large-file.txt"
[File omitted: size 2000000 exceeds limit of 1000000 bytes]
...
```

### Context Splitting

```console
$ packmime --context=1000 many-files/*
Content-Type: multipart/mixed; boundary="boundary-00"
...
$ ls packmime-overflow.*.mime
packmime-overflow.12345.000001.mime
packmime-overflow.12345.000002.mime
```

## Error Handling

- Non-fatal: Access denied, unreadable files (warning + skip)
- Fatal: Missing CLI terms, excessive recursion depth
- Exit code 0 for success, non-zero for fatal errors

## Compliance Notes

- UTF-8 validation determines base64 encoding need
- Boundary strings increment ("boundary-00", "boundary-01", etc.) to avoid content conflicts
- CRLF is default but configurable
