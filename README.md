# dv - shell scripts to use LLMs for coding

These scripts grow out of using a `packmime | llpipe | unpackmime` toolchain in collaborating with AI. They basically just enhance that toolchain.

These scripts are meant to be easy to understand and play with, so everyone can try to figure out how to make the best use of LLMs in software development.

These scripts generally assume you're in a project directory of some kind that's also a cloned git repo. They feel okay modifying git-clean content. Sometimes they make multiple subdirectory copies, to explore alternatives in parallel. Usually that would be under .dv so it wouldn't be confused with project content.

**Concurrency warning**: These scripts keep state in files, and if two people (or you working two windows) run commands that modify state, things could get very confused. Run the scripts in one window, and maybe look at the results in other windows.  Much of the state is in llpipe's history files, written in the $PROJECT_DIR/.llpipe directory. (It is fine to work on separate project dirs at the same time.)

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

## Security

Only run this stuff on an untrusted machine!!!

It would be good to include an LXC system to do that automatically for you.

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
