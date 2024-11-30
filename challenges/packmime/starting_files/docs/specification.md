# packmime - MIME Multipart Message Generator

`packmime` is a command-line utility that combines files, directories, and key-value pairs into MIME multipart messages, with support for custom formatting, size limits, and detailed control over content inclusion.

## Usage

```
packmime [options] [terms]...
```

where `terms` are any combination of:
- File paths
- Directory paths (traversed recursively)
- Key-value pairs in the format `key=value`

## Basic Operation

The tool processes terms in order, generating a MIME multipart message where:

1. Files become attachments:
```console
$ echo "test" > example.txt
$ packmime example.txt
Content-Type: multipart/mixed; boundary="boundary-00"

--boundary-00
Content-Disposition: attachment; filename="example.txt"

test
--boundary-00--
```

2. Key-value pairs become form-data:
```console
$ packmime name=value
Content-Type: multipart/mixed; boundary="boundary-00"

--boundary-00
Content-Disposition: form-data; name="name"

value
--boundary-00--
```

3. Directories are traversed recursively, processing entries in codepoint order:
```console
$ mkdir test
$ echo "1" > test/a.txt
$ echo "2" > test/b.txt
$ packmime test
Content-Type: multipart/mixed; boundary="boundary-00"

--boundary-00
Content-Disposition: attachment; filename="test/a.txt"

1
--boundary-00
Content-Disposition: attachment; filename="test/b.txt"

2
--boundary-00--
```

## Options

### Output Formatting

- `--prefix=TEXT` - Prepend text before the Content-Type header
- `--suffix=TEXT` - Append text after the final boundary
- `--preserve` - Include Content-Modified headers with file timestamps
- `--mime-types` - Include Content-Type headers for attachments
- `--lf` - Use LF line endings
- `--cr` - Use CR-LF line endings (default)

### Path Filtering

- `--ignore=PATHPATTERN` - Add pattern to ignore list
- `--use-ignore-file=FILE` - Read ignore patterns from file
- `--unignore=PATHPATTERN` - Add pattern to never ignore

### Size Limits

- `--max-file-bytes=NUMBER` - Maximum file size in bytes
- `--on-file-too-large=[skip|truncate|fail]` - Action when file exceeds size limit
- `--max-file-tokens=NUMBER` - Maximum file size in GPT-4 tokens
- `--context=NUMBER` - Maximum total output size in GPT-4 tokens

When `--context` limit is reached, additional content goes to overflow files:
```
packmime-overflow.${PID}.000001.mime
packmime-overflow.${PID}.000002.mime
...
```

### Special Handling

- `--base64=FILE` - Force base64 encoding for specified file
- `--symlink-action=[skip|follow|describe|auto]` - Control symbolic link handling

### Verbosity

- `--quiet` or `-q` or `--verbose=0` - Minimal output
- `--verbose=1` - Default, summary at end
- `--verbose=2` or `-v` - Per-part details
- `--verbose=3` or `-vv` - Processing stages
- `--verbose=4` or `-vvv` - Full debug output

### Configuration

- `--config=CONFIGFILE` - Specify config file (default: .packmime-config.json)
- `--help` - Show usage information

## Exit Status

- 0: Success
- Non-zero: Fatal error occurred

## Boundary String Selection

The boundary string starts as "boundary-00" and increments if content contains the string preceded by "--". For example:

```console
$ echo "--boundary-00" > file.txt
$ packmime file.txt
Content-Type: multipart/mixed; boundary="boundary-01"

--boundary-01
Content-Disposition: attachment; filename="file.txt"

--boundary-00
--boundary-01--
```

## Error Handling

- Inaccessible files/directories: Warning to stderr, continue processing
- Invalid filenames (containing quotes or non-space whitespace): Warning, skip
- Paths above CWD: Warning at verbose ≥ 1, continue processing
- Directory recursion > 32 levels: Fatal error
- Named CLI terms not existing: Fatal error
- UTF-8 validation failures: Automatic base64 encoding
