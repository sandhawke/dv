# Using read_named_returns

`read_named_returns` allows you to capture multiple return values from a command or function into local variables in your bash script.

## Basic Usage

```bash
read_named_returns result1 result2 -- some_command arg1 arg2
```

Everything before the `--` specifies variables to capture results into. Everything after is the command to run.

## Variable Naming

You can use two formats for specifying variables:

1. Simple format: `varname`
   ```bash
   read_named_returns result status -- process_data
   ```

2. Compound format: `filename:varname`
   ```bash
   read_named_returns output:my_result status:exit_code -- process_data
   ```

## Working with Local Variables

It works with local variables in functions:

```bash
function process_stuff() {
    local result status
    read_named_returns result:my_result status:exit_code -- complex_operation
    echo "Got result: $my_result with status: $exit_code"
}
```

## Exit Status

The function returns the exit status of the command that was run:

```bash
if read_named_returns result -- risky_operation; then
    echo "Operation succeeded with result: $result"
else
    echo "Operation failed"
fi
```
