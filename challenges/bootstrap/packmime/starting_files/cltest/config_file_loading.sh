#!/bin/bash
source $(dirname $0)/_setup.sh

# Create test config file
cat > test-config.json <<EOF
{
  "defaults": {
    "maxFileBytes": 5,
    "prefix": "START",
    "suffix": "END"
  }
}
EOF

echo "test content" > input.txt

$COMMAND --config=test-config.json input.txt > out

# Config values should be applied
assert grep -q '^START$' out
assert grep -q '^END$' out
assert grep -q 'X-Truncation-Notice' out

end_of_test
