#!/bin/bash

# Considering using your git info to populate package.json
#
# But that means the AI is seeing your name, which make you
# don't want. Hrm.

echo 'node_modules' >> .gitignore

echo '#include ".gitignore"' >> .dv/nopack.txt
echo 'package-lock.json' >> .dv/nopack.txt

