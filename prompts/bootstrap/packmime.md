Here is the specification for a simple unix command I want you to implement in nodeJS (v21+, type: module). Please just respond with the javascript text of the file, starting `#!/usr/bin/env node`. The package.json is already set up, and I can import any necessary modules. If you have any concerns, issues, or questions, put them in comments inside the program.

The command is "packmime" and its arguments are the names of files and directories which it reads recursively, and then it outputs a mime-multipart-encoded file containing each the included files as an attachement.

It does not transform the contents of the text files it is merging into the output, but simply concatenates them, divided by mime headers. If a file has an image or video or audio type, based on the filename suffix, or contains non-utf-8 characters, then the contents are base64 encoded.

Command line arguments starting with a letter and containing a '=' character are taken as setting form fields in the mime multipart output, instead of attachement files. The left side of the '=' is the field name, right right side is the field contents.

The delimiter is "--boundary-00" unless that text occurs in some of the file contents, in which case the number is incremented until there is no collision. It is okay to assume the full file contents fit easily into memory. No streaming is needed.

Add de facto standard headers to convey the file mode bits if it is executable.

Add de facto standard headers to convey the last modified time.

It follows the instructions of .gitignore in the current directory, by default, and accepts an --exclude-from= argument to set another file. It always ignores the .git directory.

It includes option starting information.

It uses proper mime line termination (cr lf).

On completion, it writes a summary to stderr of all the parts and how many bytes they are, and the total.

The attachment filenames are expressed relative to the directory the command is being run in, or another directory expressed with the --base= argument.

