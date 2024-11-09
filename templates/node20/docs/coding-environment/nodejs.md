# Software Development Environment (nodejs)

Software should be implemented in NodeJS (v20+) with ES modules.

Assume the execution container already has node and npm installed and in the PATH. If you add any dependencies, add them to package.json and assume "npm install" will be run to fetch them.

Unless the user says otherwise, use the "yargs" package for parsing CLI options. Note that yargs now returns a promise. Also, for a --version parameter, just use use yargs.version() with no parameters, which will read the version from package.json.

Unless the user says otherwise, use the "debug" package for extensive option diagnostics. Include filenames and network addresses in that output when relevant.

