llpipe is a unix command line program for talking to remote LLM AI systems using their public APIs. It currently defaults to Claude 3.5 ('claude-3-5-sonnet-latest') with 8192 max_tokens.

In normal operations, llpipe reads stdin and uses it as the user prompt for the LLM. The response from the LLM is streamed to stdout.

llpipe uses the environment variable LLPIPE_CONFIG to determine where to maintain its state files. If not set, this defaults to ./.llpipe, that is ".llpipe" in the current directory.

Each round of using llpipe results in new directory $LLPIPE_CONFIG/history/$HISTID, where HISTID is an integer, increasing with each run, starting at 1. At the start of a run, start.json is written into that directory, including the command line arguments and timestamp. At the end, messages.json is written, which is the LLM messages object as using in the OpenAI and Anthropic conversation APIs.

## new

The command `llpipe new` reads stdin for the user prompt and makes this new history step start a new conversation with that prompt and its response.

An optional --system-prompt FILE may be provided with `new`, and to be used as the system prompt at the start of the conversation.

## more

The command `llpipe more` reads stdin for the user prompt and makes this new history step continue the conversation in the previous history step.

## LLM selection

If the environment variable LLPIPE_INNER is set, it is a unix command to be executed on a unix pipe in the place of connecting to the LLM. What would normally be sent to the remote LLM is instead written over that pipe, and what would be read back is instead read from the pipe. This feature is used in the test suite, and also for working with LLMs which LLPIPE does not know how to talk to. Test scripts can simply make this be a command to confirm it receives the expected content and outputs some other expected content.

Otherwise, the environment variable ANTHROPIC_API_KEY must be set.

## Details

* messages.json should just be in the format for sending to an LLM like Claude.

* if a rate limit is reached, print an explanation on stderr, including a calculation of when operation can continue; then sleep until that time before continuing.

* do not worry about retrying in the event of network or LLM failures

* do not worry about concurrent access to files or files being corrupted

## Demo

```terminal
$ echo 'in a word, what color is the sky' | llpipe new
Blue
$ echo 'at night?' || llpipe more
Black
$ echo 'at dawn?' || llpipe
usage: llpipe <command>

commands:
   new [--system-prompt FILE]
   more

$
```
