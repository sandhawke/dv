# Using write_named_returns

`write_named_returns` is used within commands to send values back to `read_named_returns`. It writes the values of variables to be picked up by the caller.

## Basic Usage

```bash
write_named_returns result status
```

## Variable Naming

Like `read_named_returns`, you can use two formats:

1. Simple format: Use the same name for both sides
   ```bash
   result="Hello"
   status="ok"
   write_named_returns result status
   ```

2. Compound format: Use `filename:varname` to use different names
   ```bash
   my_result="Hello"
   exit_code="ok"
   write_named_returns output:my_result status:exit_code
   ```

## Example Function

Here's a complete example:

```bash
function process_data() {
    local result="calculation complete"
    local status="success"
    
    # Do some work...
    
    write_named_returns result status
}

function caller() {
    local my_result my_status
    read_named_returns result:my_result status:my_status -- process_data
}
```

## Important Notes

- Only works when called from within a command being run by `read_named_returns`
- Silently does nothing if not called from `read_named_returns`
- Variables that are empty or unset are skipped
- Values are written exactly as-is, preserving special characters and whitespace
- The using_named_returns function can be use like `if using_named_returns; then...` for better UX.