# dv - shell scripts to use LLMs for coding

These make heavy use of llpipe and plainpack, which make it pretty easy to work with LLMs from the command line.

These scripts are meant to be easy to undestand and play with, so everyone can try to figure out how to make the best use of LLMs in software development.

The directory structure is important. dv should be run from a new directory for each project, called PROJECT_DIR in the scripts. This should have a subdirectory $PROJECT_DIR/input with all the files you want the LLM to start with, such as your spec, example code, any code that's already written, and documentation for any APIs it needs to work with.

*ISSUE*: If you tweak ./input, can we propagate those changes nicely, keeping good work that's been done? What about if you add a manual instruction along the way?

New subdirectories of PROJECT_DIR will be created as dv does its work, showing what it's come up with. One subdirectory, $PROJECT_DIR/latest will be a copy of the output from the latest run, so you can sit in that directory and watch things change as iterations run. Go back up to PROJECT_DIR to see the iterations as separate subdirectories.

*ISSUE*: Should we use git branches instead of subdirectories? Let's try this first, and someone with more experience in teams using LLMs with git can make a git version.

**Concurrency warning**: These scripts keep state in files, and if two people (or you working two windows) run commands that modify state, things could get very confused. Run the scripts in one window, and maybe look at the results in other windows.  Much of the state is in llpipe's history files, written in the $PROJECT_DIR/.llpipe directory. (It is fine to work on separate project dirs at the same time.)

## Demo

```terminal
$ mkdir dv-demo
$ cd dv-demo
$ mkdir input
$ cat <<_END > input/README.md
This is portmon, a CLI tool to display an overview of network traffic on the
current machine, showing what ports are being used by which programs, and their
traffic levels.'
_END
$ export ANTHROPIC_API_KEY="sk-ant-api03-..."
$ dv-medium
$ #... go get coffee while Claude writes a test suite and code to pass it
$ latest/bin/portmon
```

## Installation

To install, clone the repo then add its bin directory to your path. No compilation is required as all tools are shell scripts. You will need /bin/bash on your system, along with llpipe and plainpack.

1. Clone the repository:
```
git clone https://github.com/sandhawke/dv.git
```

2. Add the `bin` directory to your PATH:
```
echo 'export PATH="$PATH:/path/to/where/you/put/dv/bin"' >> ~/.bashrc
source ~/.bashrc
```

## Commands

### All-in-one

Read these to see examples of using the others:

* dv-easy - go through the steps to create code, expending a low level of resources
* dv-medium - go through the steps to create code, expending a medium level of resources
* dv-hard - go through the steps to create code, expending a high level of resources

### Developing specs

These can be skipped if you have a solid spec.

You need to start with some guidance, at least a few words saying generally what you want. Put this in some file(s) like ./input/README.md or ./input/docs/spec.md. The more detailed you can be, the more likely you are to get something you want.

* dv-spec-new - start a chat to flesh out a spec
* dv-spec-improve - add to a chat, asking for improvements

It's good to read over what's been produced and make sure it's what you want implemented.

### Developing tests

* dv-tests-new - start a chat to create or revise a test suite
* dv-tests-improve - add to a chat, asking for improvements
* dv-tests-synth - start a chat looking at multiple test suites, hoping to take the best of all of them

### Developing code

* dv-code-new
* dv-code-improve
* dv-tests-run - run a test suite
* dv-code-debug
* dv-code-synth

## Security

We generally run untrusted code inside an LXC container to provide some degree of isolation.

## Evaluating dv

When you change dv's logic or its prompts, how do you know if you've made an improvement? Can you tell which LLMs are better? There's some real randomness in LLM execution that makes them hard to measure.

One approach to systematic testing of dv is to ask it to re-implement standard unix commands. This has the downside that the source code is probably in the training data. However, if that were enough, they're routinely pass this test and they don't. For one thing, the code is usually much larger than the generation max_tokens limit.

For our baseline testing, we select a few well-known unix commands which run as a single process as an unprivileged user.

* Ten from fileutils: chmod cp dd df du ln ls mkdir mv touch
* Ten from textutils: cat cut head od sort split tail tr uniq wc
* Five very hard: grep find tar awk gzip
* Five extremely hard: ffmpeg busybox bash gcc python

On advantage of this approach is we can see if the test suite accepts the system implementations.

dv-self-test COMMAND-or-PATTERN...

* tests are named like file-* text-* hard-* extreme-*

Makes dv-self-test.DATE and puts the output there


