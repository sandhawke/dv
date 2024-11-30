# packmime01 - Core MIME Multipart Generator

A simplified version of packmime that handles the essential functionality of combining files, directories, and key-value pairs into MIME multipart messages.

## Usage

```
packmime01 [terms]...
```

where `terms` are any combination of:
- File paths
- Directory paths (traversed recursively)
- Key-value pairs in format `key=value`

## Core Operation

1. Processes terms in order
2. Uses "boundary-00" as boundary string, incrementing if needed
3. Files become attachments with filename
4. Key-value pairs become form-data with name
5. Directories traversed recursively, entries sorted by codepoint

## Output Format

1. Content-Type header with boundary
2. For each term:
   - Files: Content-Disposition: attachment; filename="path"
   - Key-values: Content-Disposition: form-data; name="key"
3. Final boundary with "--" suffix

## Rules & Behavior

1. Paths are relative to CWD and normalized
2. Directory entries processed in codepoint order
3. Invalid UTF-8 files auto-base64 encoded
4. Max directory depth: 32
5. Skip unreadable files/dirs with warning
6. Boundary auto-increments if content collision

## Input Validation

1. Reject paths with quotes or non-space whitespace
2. CLI terms must exist
3. Paths must be UTF-8 clean
4. Directory depth ≤ 32

## Error Handling

1. Unreadable files: Warning, continue
2. Invalid paths: Warning, skip
3. Missing CLI terms: Fatal
4. Depth > 32: Fatal
5. UTF-8 failures: Auto base64

## Exit Status

- 0: Success
- Non-zero: Fatal error

## Examples

```console
# Single file
$ echo "test" > example.txt
$ packmime01 example.txt
Content-Type: multipart/mixed; boundary="boundary-00"

--boundary-00
Content-Disposition: attachment; filename="example.txt"

test
--boundary-00--

# Key-value pair
$ packmime01 name=value
Content-Type: multipart/mixed; boundary="boundary-00"

--boundary-00
Content-Disposition: form-data; name="name"

value
--boundary-00--

# Directory
$ mkdir test && cd test
$ echo "1" > a.txt
$ echo "2" > b.txt
$ packmime01 .
Content-Type: multipart/mixed; boundary="boundary-00"

--boundary-00
Content-Disposition: attachment; filename="a.txt"

1
--boundary-00
Content-Disposition: attachment; filename="b.txt"

2
--boundary-00--
```
