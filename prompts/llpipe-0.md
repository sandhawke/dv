Here is a program spec.  Do not implement the program yet, but consider how it might be implemented in NodeJS (v18+).

Please read the spec carefully and think about how to make a clean, simple, reliable implementation.

Write a brief description of how the implementation will work, and write a shell script to thoroughly test the program.

Please use artifacts for your output.

===

llpipe is a unix command line program for talking to remote LLM AI systems using their public APIs. It currently defaults to Claude 3.5 ('claude-3-5-sonnet-latest') with 8k max_tokens.

In normal operations, llpipe reads stdin and uses it as the user prompt for the LLM. The response from the LLM is streamed to stdout.

llpipe is configured by environment variables, files, and command line arguments. LLPIPE_CONFIG is a directory where files may be found and defaults to ./.llpipe, that is ".llpipe" in the current directory.

If the file $LLPIPE_CONFIG/system-prompt.txt exists, it sent as a system prompt at the start of the message history array. If not, there is no system prompt.

At the start of running, llpipe creates the numerically next HISTID in the history directory, $LLPIPE_CONFIG/history. At the end of running, it writes messages.json there, including the whole message chain it used, and the response it got.

If the option [--after HISTID] is present, llpipe looks for file $LLPIPE_CONFIG/history/HISTID/messages.json and, if found, includes those user and assistant messages in the message array after any system message and before the current user message. In practice, this means the user can say "llpipe --after 6" to continue a conversation differently that had gotten 6 steps in.

If the option [--more] is present, it is treated like --after, with a HISTID that is selected as the numerically highest HISTID in $LLPIPE_CONFIG/history. In practice, this means the user can say "llpipe --more" to simply continue the conversation.

If the option [--new] is present, the history array is not sent. The remote LLM is only the sent the current user input, and the system prompt (if any).

If the option [--list] is present, a summary table of the history is present, one line per history entry, the number of exchanges in the resulting history array, and the leading substring of the user prompt.

If the option [--pull HISTID] is present, the bytes returned by the LLM in history stage HISTID are send to stdout.

If the environment variable LLPIPE_INNER is set, it is a unix command to be executed on a unix pipe in the place of connecting to the LLM. What would normally be sent to the remote LLM is instead written over that pipe, and what would be read back is instead read from the pipe. This feature is used in the test suite, and also for working with LLMs which LLPIPE does not know how to talk to.

## Details

* messages.json should just be in the format for sending to an LLM like Claude.

* also write a meta.json file, next to messages.json at each history step which include details of the operation at that step, like timestamps. Do not bother to record how the results in the steam are chunked. Write error.json with all available details if there is an error.

* if a rate limit is reached, print an explanation on stderr, including a calculation of when operation can continue; then sleep until that time before continuing.

* do not worry about retrying in the event of network or LLM failures

* get the API key from ANTHROPIC_API_KEY or OPENAI_API_KEY and give a clear error if they're both missing.

* do not worry about concurrent access to files or files being corrupted

* as a simple test, "echo 'in a word, what color is the sky?' | llpipe -new" should output "Blue."