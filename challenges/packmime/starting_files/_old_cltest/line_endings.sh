#!/bin/bash
echo "test" > input.txt
output_lf=$($COMMAND --lf input.txt)
output_cr=$($COMMAND --cr input.txt)
[ $? -eq 0 ] &&
  [[ "${output_lf}" == *$'\n'* ]] &&
  [[ "${output_cr}" == *$'\r\n'* ]] &&
  [[ "${output_lf}" != *$'\r\n'* ]]
