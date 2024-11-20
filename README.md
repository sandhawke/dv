# dv - shell scripts to use LLMs for coding

These are scripts to help software engineers use LLMs (GPT4, Claude, etc) in software development. They are shell scripts because they're meant to be easy to modify, refactor, and use in different ways.

For simple stuff, it's like copying/pasting to the chat service, but you save some clicks. But since it's automated, now we can write higher-level scripts, like having the LLM see it's failing the test suite and try again.

The basic idea of how we interact with an LLM from the command line is:
1. Package some files and some prompts. We use packmime for this.
2. Send them to an LLM and wait for a response. We use llpipe for this.
3. Unpack the response into new files and modified files. We unpackmime for this.

The current version does not use chat history, because it doesn't seem to offer much benefit and makes things more complicated.

## Security

Only run this stuff on an untrusted machine, like a fresh cloud host. We end up executing lots of code, such as tests, written by the LLM. It could easily delete or corrupt files on whatever machine it runs.

It would be good to include an LXC system to make this all more convenient.

Do not trust any of the software made by an LLM until you've carefully reviewed it.

The selection and authentication of LLM service (eg API keys) is done via llpipe.

## Installation

To install, clone the repo then add its bin directory to your path. No compilation is required as all tools are shell scripts. You will need /bin/bash on your system, along with a few other shell commands.

1. Clone the repository:
```terminal
git clone https://github.com/sandhawke/dv.git
```

2. Add the `bin` directory to your PATH:
```terminal
echo 'export PATH="$PATH:/path/to/where/you/put/dv/bin"' >> ~/.bashrc
source ~/.bashrc
```
3. Install the dependencies:
```terminal
npm install -g llpipe packmime unpackmime
```

Alternatively, you can try re-creating those NPM dependencies using AI. Prompts for doing so are in ./bootstrap.

## Demo

Here's an example using a fairly high-level script.

```console
$ dv-init
$ echo 'Program to print the primes between its two arguments, one per line, runnable as node ./src/primes.js' > docs/user-request.md
$ git add -A && git commit -m'rough spec'
$ dv-sequence-basic
$ node src/primes.js 9000 9040
9001
9007
9011
9013
9029
```

At this point, the git history should show the details of every iteration with the AI.

Definitely look at what dv-sequence-basic does, and try different prompts, etc.

## Commands

### dv-ask

Simple basic command, essentially `packmime | llpipe`.

```console
$ dv-ask --prompt='In a word, with no punctuation, what color is the sky'
...
Blue
...
$ echo "What is one plus seven" > problem-1
$ echo "Who was the first president of the US" > problem-2
$ dv-ask -p'Please provide answers' . # output varies
I'll provide answers to both problems: For problem-1: One plus seven equals 8 For problem-2: George Washington was the first President of the United States. He served two terms from 1789 to 1797.
```

### dv-edit

This is basic workhorse command, essentially `packmime | llpipe | unpackmime`.

Let's start again. This time, we'll put the files in git so we can see and
control all the file changes the AI makes.

```console
$ dv-init
$ echo "What is one plus seven" > problem-1
$ echo "Who was the first president of the US" > problem-2
$ git add -A && git commit -q -m'initial files'
$ dv-edit -p'Please modify the problem files to include their answers' . # output varies
I will modify the problem files to include their answers. I'll append the answers after the questions, separated by a line containing "Answer:".
$ more prob* # output varies
::::::::::::::
problem-1
::::::::::::::
What is one plus seven

Answer: 8
::::::::::::::
problem-2
::::::::::::::
Who was the first president of the US

Answer: George Washington
```

At this point you may want to:

* `git show`                 # show what changed
* `git log --oneline`        # overview of all the steps taken
* `git reset --soft HEAD~1`  # uncommit, so you can revise a bit
* `git reset --hard HEAD~1`  # complete undo that step
* `git commit --amend`       # edit the commit message

### dv-edit-OBJECT-ACTION

This is a set of commands which you're encouraged to extend. Each one is a call to dv-edit with a hard-coded prompt, and sometimes shell actions before and after the dv-edit call.

Examples (some TBD):

* dv-edit-spec-create
* dv-edit-spec-improve
* dv-edit-shelltest-create
* dv-edit-shelltest-improve
* dv-edit-plan-create
* dv-edit-plan-improve
* dv-edit-code-create
* dv-edit-code-improve
* dv-edit-unittest-create
* dv-edit-code-debug
* dv-edit-release-create

Some of the actions they typically include:

* dv-file-exists

### dv-install

Copies files from dv's templates directories into the project directories. Typcially used to set up boilerplate for development in a given language, with some additional bits of opinion.

```console
$ dv-install node20
```

### dv-test

Run the test scripts, saving the results into $DV_DIR_TO_AI/test-results

### dv-tool-runner

Runs the tool requests (eg npm search) and makes the responses available.

With --show-prompt, output a prompt which tells folks how to use dv-tool-runner.

Currently reads from _from_developer and writes to _to_developer, but
there's some indication it would work better just working in ./notes.

