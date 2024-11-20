# dv - shell scripts to use LLMs for coding

These are scripts to help software engineers use LLMs (GPT4, Claude, etc) in software development. They are shell scripts because they're meant to be easy to modify, refactor, and use in different ways.

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

```console
...
$ dv-edit --force -p'Please modify the problem files to include their answers'
...
$ more * | cat
```

Normally, we don't use `--force` because we don't trust the LLM to do
exactly what we want.

Instead, we use git to keep our version safe. Then, when dv-edit changes things, we can see the change and revert it if necessary.

Let's do that again from the start:

```console
$ echo "What is one plus seven" > problem-1
$ echo "Who was the first president of the US" > problem-2
$ git init && git add -A && git commit -m'initial files'
...
 create mode 100644 problem-1
 create mode 100644 problem-2
$ dv-edit -p'Please modify the problem files to include their answers' . # output varies
I will modify the problem files to include their answers. I'll append the answers after the questions, separated by a line containing "Answer:".
```

### dv-commit

Stages and commits all the changes in the working space. Typically done after dv-edit, if the changes look good. Tries to uses a commit message created by the LLM during the edit, and adds a dv tag to the git author string.

You may use `dv-settings auto-git-commit=true` to make dv-edit run dv-git-commit automatically after a successful edit. You may, of course, still roll back the changes (Eg: `git reset --hard HEAD~1`). This mode is especially useful if you're running dv-edit as a step in a longer process, and then want to use git tools to see everything that happened.

dv-git-commit does **not** do a `git push`, and you'll want to carefully review all the changes before doing that.

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

### dv-issue-create

Create a new issue note, typically to be addressed by the next run of the LLM.











----




There are lots of directory structure assumpts these sc

These scripts generally assume you're in a project directory of some kind that's also a cloned git repo. They feel okay modifying git-clean content and maybe commiting changes. Sometimes they make multiple subdirectory copies, to explore alternatives in parallel. Usually that would be under .dv so it wouldn't be confused with project content.



## Demo

```terminal
$ export ANTHROPIC_API_KEY="sk-ant-api03-..."
$ pushd $(mktemp -d)
$ echo "This is a re-implementation of 'tee' based on the man page" > README.md
$ echo "node_modules" >> .gitignore
$ echo "_from_developer" >> .gitignore
$ dv-coding-setup
$ git init
$ git add --all
$ git commit -m'initial commit'
$ dv-coding-step
$ dv-coding-step
$ dv-coding-step
...
```

There are some older scripts like dv-self-test that need to be updated

## Security

Only run this stuff on an untrusted machine, like a fresh cloud host.

It would be good to include an LXC system to do that automatically for you.

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

Alternatively, you can try re-creating the dependencies using AI. Prompts for doing so are in ./bootstrap.

## Evaluating dv (not working)

When you change dv's logic or its prompts, how do you know if you've made an improvement? Can you tell which LLMs are better? There's some real randomness in LLM execution that makes them hard to measure.

One approach to systematic testing of dv is to ask it to re-implement standard unix commands. This has the downside that the source code is probably in the training data. However, if that were enough, they're routinely pass this test and they don't. For one thing, the code is usually much larger than the generation max_tokens limit.

For our baseline testing, we select a few well-known unix commands which run as a single process as an unprivileged user.

* Ten from fileutils: chmod cp dd df du ln ls mkdir mv touch
* Ten from textutils: cat cut head od sort split tail tr uniq wc
* Five very hard: grep find tar awk gzip
* Five extremely hard: ffmpeg busybox bash gcc python

On advantage of this approach is we can see if the test suite accepts the system implementations.

```terminal
$ dv-self-test TEXT
... runs the ten textutil tests
```
