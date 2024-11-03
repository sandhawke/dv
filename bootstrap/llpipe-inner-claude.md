Here is the specification for a simple unix command I want you to implement in nodeJS (v21+, type: module). Please just respond with the javascript text of the file, starting `#!/usr/bin/env node`. The package.json is already set up, and I can import any necessary modules. If you have any concerns, issues, or questions, put them in comments inside the program.

The command is "llpipe-inner-claude" and it reads all bytes from stdin as a utf-8 string, sends that string packaged as a user prompt to Anthropic's Claude AI, awaits the response, and either prints the error message to stderr or, if no error, prints to stdout the AI response text for the user.

If the environment variable LLPIPE_LOG_RESPONSE is set, the program should write the LLM's raw HTTP response (the headers, a blank line, and the body) to the filename in that variable.

Use model "claude-3-5-sonnet-latest" and set max-tokens to 8192.

In order to have access to the raw HTTP headers and minimize dependencies, use the build-in fetch() function to access the Anthropic API, not any library.