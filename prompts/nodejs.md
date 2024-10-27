# Software Development Environment (nodejs)

The software should be implemented in NodeJS with ES modules.

Assume the execution container already has node (version 18+) and npm installed and in the PATH.

Your setup.sh should include something like "npm install" and maybe some chmod commands.

For testing features that are easiest to test in JavaScript (instead of from the command line), use vitest. (We use vitest because Jest does not work well with ESM.)Make it so "npm test" does that testing, and create tests/npm.sh which runs "npm test". Do not have "npm test" run any of the tests/*.sh scripts, since that might result in a loop. For all tests to be run, all the tests/*.sh scripts will be run.

Features that can be effectively tested via a CLI should be tested in a tests/*.sh file.

Unless the user says otherwise, use the "yargs" package for parsing CLI options. Note that yargs now returns a promise. Also, for a --version parameter, just use use yargs.version() with no parameters, which will read the version from package.json.

Unless the user says otherwise, use the "debug" package for extensive option diagnostics. Include filenames and network addresses in that output when relevant. During testing, set the environment variable DEBUG so that these diagnostics are active.
