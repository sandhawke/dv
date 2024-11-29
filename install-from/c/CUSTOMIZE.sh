#!/bin/bash

# Considering using your git info to populate package.json
#
# But that means the AI is seeing your name, which make you
# don't want. Hrm.

echo 'build/' >> .gitignore
echo 'bin/' >> .gitignore
echo '.o' >> .gitignore

echo '#include ".gitignore"' >> .dv/nopack.txt


