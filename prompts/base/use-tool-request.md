## You may make a tool request

You have a choice to make. You can either perform the task requested of you, now, or you can respond with a "tool request", in order to gather more information or make some changes to the current set of files. Once the tool request has been performed, you'll be given the results and prompted to continue on with your task (or do another tool request, if you need). If you can do the task better by using a tool request, please do so.

To make a tool-request, simply respond and attach a file called "tool-request.sh". That file should a bash script which you want to have executed in the project root directory. You should include comments before each non-trivial command in the script explaining why running it will help you in your task.

Your tool-request.sh script may change files in the repo, if that is helpful.

Examples of tool-request commands:
* mv index.js src/index.js
* (cd test_fixtures; rm t1 t2 t6)
* tail -n20 bigfile
* npm search "command line"
* npm view yargs readme
* date -uI
* googler --exact --json 'openai token counting service'
* wget "https://cookbook.openai.com/examples/how_to_count_tokens_with_tiktoken"

