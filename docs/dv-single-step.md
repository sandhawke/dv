# dv-single-step

A utility for executing commands one at a time from a file, with failure tracking and statistics.

## Overview

`dv-single-step` executes commands from a file sequentially, one command per invocation. If a command fails, the next invocation will retry that command. Progress and detailed statistics are maintained between runs.

## Features

- Executes one command per invocation
- Automatically retries failed commands
- Tracks execution statistics (timing, success/failure counts)
- Supports dry-run mode
- Can list all steps with their status
- Maintains state between runs
- Prevents concurrent execution via file locking
- Skips blank lines and comments

## Installation

```bash
chmod +x dv-single-step
cp dv-single-step ~/bin/  # or another location in your PATH
```

## Usage

```bash
dv-single-step [OPTIONS] CMDFILE

Options:
  --state=NAME    Use state file NAME (default: default)
  --reset=N       Reset to make step N the next to execute
  --list          Show all steps with status and stats
  --dryrun        Show what would be executed next
  --help          Show this help message
```

## Working Example

Here's a complete working example showing the main features:

```bash
# Set up a test environment
export HOME=$(mktemp -d)
mkdir -p $HOME/bin
cp dv-single-step $HOME/bin/
export PATH=$HOME/bin:$PATH

# Create a test command file
cat > cmds.txt << 'EOF'
echo "Step 1"
# This is a comment - it will be skipped
echo "Step 2" && sleep 1
false  # this step will fail
echo "Step 4"
EOF
```

Run the first command:
```bash
$ dv-single-step cmds.txt
Executing step 0: echo "Step 1"
Step 1
Step 0 completed successfully in 0.001234s
```

Run the second command:
```bash
$ dv-single-step cmds.txt
Executing step 1: echo "Step 2" && sleep 1
Step 2
Step 1 completed successfully in 1.002345s
```

Try the failing command:
```bash
$ dv-single-step cmds.txt
Executing step 2: false
Step 2 failed with exit code 1 (0.000123s)
Run step again to retry
```

List all steps and their status:
```bash
$ dv-single-step --list cmds.txt
Step 0: echo "Step 1"
  ✓ Last success: 2024-11-17T10:00:00Z
    Duration: 0.001234s

Step 1: echo "Step 2" && sleep 1
  ✓ Last success: 2024-11-17T10:00:01Z
    Duration: 1.002345s

→ [Current]
Step 2: false
  ✗ Failed 1 times
    Total failure time: 0.000123s
    Last failure: 2024-11-17T10:00:02Z

Step 3: echo "Step 4"
```

Preview the next execution:
```bash
$ dv-single-step --dryrun cmds.txt
Next command to execute:
Step 2: false
  ✗ Failed 1 times
    Total failure time: 0.000123s
    Last failure: 2024-11-17T10:00:02Z
```

Reset to the beginning:
```bash
$ dv-single-step --reset=0 cmds.txt
Reset to step 0
```

Start over with a different state file:
```bash
$ dv-single-step --state=test2 cmds.txt
Executing step 0: echo "Step 1"
Step 1
Step 0 completed successfully in 0.001234s
```

## State Files

State is maintained in `~/.step/` directory:
- Default state file: `~/.step/default`
- State files are JSON format with execution history
- Automatic backups are created before modifications
- File locking prevents concurrent execution

## Error Handling

- Non-zero exit codes are treated as failures
- Failed commands will be retried on next execution
- Full command output is displayed
- Timing statistics are maintained for both successes and failures

## Tips

1. Use comments in your command file to document complex steps
2. Check status with `--list` before running after a break
3. Use `--dryrun` to preview the next action
4. Create different state files for different workflows with `--state`
5. Reset to any step with `--reset=N` if you need to rerun a section