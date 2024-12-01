#!/bin/bash
source $(dirname $0)/_setup.sh

cat <<'_END' > hello.c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
_END

cc hello.c -o hello
./hello > out

assert ! [ "$(< out)" = 'Hello, World!' ]
# end_of_test
