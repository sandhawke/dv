# Software Development Environment (nodejs)

Software should be implemented in NodeJS (v20+) with ES modules.

Assume the execution container already has node and npm installed and in the PATH.

If anything will need to be installed by npm, make sure there is a ./setup.sh script which includes "npm install" for any dependencies. It may also make chmod commands if needed.

For unit tests and integration tests, use the native NodeJS test system.

To integrate this with our overall shell-script based test system, make sure ./test/npm.js runs "npm test". Do not have "npm test" run any  of the ./test/*.sh scripts, since that might result in a loop.

Features that can be effectively tested via a CLI should be tested in a tests/*.sh file. Do not make JS tests that open a shell to test the CLI.

Unless the user says otherwise, use the "yargs" package for parsing CLI options. Note that yargs now returns a promise. Also, for a --version parameter, just use use yargs.version() with no parameters, which will read the version from package.json.

Unless the user says otherwise, use the "debug" package for extensive option diagnostics. Include filenames and network addresses in that output when relevant. Do not worry about personal data being leaked in debug output; assume it will be kept highly secure.



