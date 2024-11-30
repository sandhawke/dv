
I want a program called 'packmime' that combines files using mime-multipart encoding.

packmime [options] [terms]...

The 'terms' are files, directories, or key=value pairs. Order is significant. Directories are traversed recursively to obtain files and more directories to include. When a directory is read, the entries in it are sorted by codepoint before processing, so file or directory "0" comes before "B" which comes before "a". Files turn into sections starting Content-Disposition: attachment; filename="<path>". key=value pairs turn into Content-Disposition: form-data; name="<key>" with the content being the value.

Options are:

--prefix=TEXT

Text to prefix on the output, before the opening Content-Type: multipart/mixed; boundary="boundary-..." line

--suffix=TEXT

Text to append to the end, after the final --boundary-...--

--ignore=PATHPATTERN

Add PATHPATTERN to the list of ignore patterns, used like lines in .gitignore. Maybe be repeated. Ignored directories are still traversed, since their files and subdirectories may still be included in the output due to unignore rules.

--use-ignore-file=FILE

File to process like .gitignore, specifying paths and path prefixes to skip over and not include in the output (unless they are explicitely included with a --include= option). Maybe be repeated to add multiple files to be read like this.

--unignore=PATHPATTERN

Adds an inverse pattern. Paths that match one of the unignore patterns are immune from being ignored via the --ignore / --use-ignore-file logic. 


--on-file-too-large=[skip|truncate|replace|fail]

Default 'replace', which replaces content with a message about it being omited since it is too large, stating its size and the max size. 'fail' means the program halts, with an error exit code, possibly leaving a partially generated mime file.  A file is considered too large if either --max-file-bytes or --max-file-tokens is reached for that file.

--max-file-bytes=NUMBER

Maximum byte length of a file to include, the point at which it triggers the --on-file-too-large action. This is the filesystem size of the file, which can be determined without reading it. Files over this size should not be read. This is bytes, not the character string length after utf8 decoding, nor after base64 encoding.

--max-file-tokens=NUMBER

Maximum token length of a file to include, in tokens calculated using OpenAI gpt4 tokenization (encoding cl100k_base).  https://github.com/openai/tiktoken for python. https://www.npmjs.com/package/js-tiktoken for js.  etc. This may not be perfect for all models, so view it as an approximation.

--context=NUMBER

Sets the max number of gpt4 tokens to be generated in the output. Before a file is included, a check is made to see if this number will be reached (by including the file and any --suffix). If the number would be reached, the file is not included, and instead the multipart message is concluded.  Additional files are processed into addition messages, repeating the --prefix and --suffix, as necessary to attach all content. The additional files, instead of being writtent to stdout, and written to files packmime-overflow.${PID}.${part}.mime where part is a 6 digit zero-padded sequence number starting at 000001.  (Conceptually, 000000 was the first one, but that content went to stdout.)

--help

the usual

--preserve

Write `Content-Modified: ${file.stats.mtime.toISOString()}\r\n` header lines for each attachment

--mime-types

Write `Content-Type: ...` header lines for each attachment. This option is required for string RFC conformance, but it not generally helpful for LLM use.

--lf

Just use LF for line endings, instead of CR-LF. The default is CR-LF, but it might be changed in a config, which this flag overrides.

--cr

Use CR-LF for the line endings. The default is CR-LF, but it might be changed in a config, which this flag overrides. This option is required for string RFC conformance, but it not generally helpful for LLM use.

--base64=FILE

Signals mime base64 encoding should be used when attaching this file. For files without this flag, they are checked to see if they are UTF-8. If they fail to decode as UTF-8, then they are base64 encoded for transmission. If they can successfully be decoded as UTF-8 they are just transmitted as UTF-8, assuming the path is UTF-8 clean.

--symlink-action=[skip|follow|describe|auto]

When reaching a symbolic link, the action says what to do. 'follow' means the content at the target will be attached as if it were a normal file. 'skip' means it will be omitted'. 'describe' means at this point in the output, we emit a form-data element, key "symbolic-link", value "${sourcePathName} is a symbolic link to ${targetPathname}". 'auto' means use 'describe' if the target is somewhere in this mime message we're building and 'follow' if it is not. Default: auto.

--verbose=0 or --quiet or -q

No output to stderr except in the case of fatal errors

--verbose=1 (default)

At the end, print one line summarizing the number of parts and the total bytes and tokens of the output

--verbose=2 -v

At the end, output each part, and give a summary of how many characters and tokens it consumes (with its headers, as encoded), and the totals.

--verbose=3 -vv

Output general stages of processing, with color coding.

--verbose=4 -vvvv

Output details, include directory tranversal details and processing of ignore/include patterns, with color coding.

--config=CONFIGFILE

Defaults to .packmime-config.json

## Notes

The boundary string should be "boundary-00" unless that text occurs in the content (preceeded by '--'), in which case the number should be incremented until the string does not occur in the content. This logic means we need to read files twice or buffer the contents of one mime message in memory. Given that we're preparing messages that need to fit in an LLM context, buffering in memory should be acceptable. That way we can also do token counts and make sure everything fits before writing anything to stdout. From an encoding perspective it would be far more efficient to generate a uuid as the boundary, but the primary audience of packmime output is LLMs, and it would be a waste of their resources to give them unnecessary UUIDs.

If files are reached for which we do not have read access, or we reach directories which cannot be traversed, print a warning to stderr and skip them. These must not be fatal errors.

The pathname of the parameter for Content-Disposition should be relative to the current working directory, even if specified as an absolute path on the command name, and it shouold be canonicallized, removing unnecessary '.' and '..' segments and otherwise normalizing paths names. Skip with a warning any path names include quote characters (") or whitespace other than space (0x20). Relative paths above the CWD are allowed, but a warning should be issued at or above --verbose=1.

MIME headers do count toward token limits. base64 content is has its tokens counted after being base64 encoded.

Recursive directory depth should max at 32 and give a fatal error.

Exit code should be 0 unless a fatal error occured, such as one of the named file/dir terms on the CLI not existing.
