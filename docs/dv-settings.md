# DV Settings Management Tool

A simple command-line tool for managing project-level settings in DV projects. Settings are stored in individual files under the `.dv/settings` directory in your project.

## Prerequisites

- Bash shell
- `DV_PROJECT_DIR` environment variable must be set to your project directory

## Installation

1. Save the script as `dv-settings` in a directory in your PATH
2. Make it executable:
```console
$ chmod +x dv-settings
```

## Usage

### Setting a Value

To set a setting, use the format `key=value`:

```console
$ dv-settings auto-git-commit=true
Setting 'auto-git-commit' set to 'true'

$ dv-settings build-target=production
Setting 'build-target' set to 'production'
```

### Reading a Value

To read a single setting, provide the key name:

```console
$ dv-settings auto-git-commit
true

$ dv-settings build-target
production
```

### Listing All Settings

To see all current settings, run the command with no arguments:

```console
$ dv-settings
auto-git-commit=true
build-target=production
debug-mode=false
```

### Checking Settings in Scripts

The `--check` flag is useful in scripts to test if a setting matches an expected value. The command will exit with status 0 if the value matches, and status 1 if it doesn't match or the setting doesn't exist.

```console
$ if dv-settings --check auto-git-commit=true; then
>   echo "Auto git commit is enabled"
> fi
Auto git commit is enabled

$ dv-settings --check debug-mode=true || echo "Debug mode is not enabled"
Debug mode is not enabled
```

### Error Handling

The script provides clear error messages:

```console
$ dv-settings unknown-setting
Setting 'unknown-setting' not found

$ unset DV_PROJECT_DIR
$ dv-settings auto-git-commit
Error: DV_PROJECT_DIR environment variable is not set
```

## File Structure

Settings are stored in individual files under the `.dv/settings` directory in your project:

```console
$ ls -l $DV_PROJECT_DIR/.dv/settings/
total 12
-rw-r--r-- 1 user user 4 Nov 16 10:00 auto-git-commit
-rw-r--r-- 1 user user 10 Nov 16 10:00 build-target
-rw-r--r-- 1 user user 5 Nov 16 10:00 debug-mode
```

## Example Script Usage

Here's a practical example of using the settings in a deployment script:

```bash
#!/bin/bash

# Check if we should commit before deploying
if dv-settings --check auto-git-commit=true; then
    git add .
    git commit -m "Auto-commit before deployment"
fi

# Get the build target
target=$(dv-settings build-target)
echo "Deploying to $target environment..."

# Enable extra logging if in debug mode
if dv-settings --check debug-mode=true; then
    export VERBOSE=1
    export DEBUG=1
fi
```

## Exit Codes

- 0: Success / Setting matches expected value
- 1: Error / Setting doesn't match or doesn't exist

## Environment Variables

- `DV_PROJECT_DIR`: Must point to your project's root directory