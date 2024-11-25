# Common test functions and setup

create_test_file() {
    local lines=$1
    local file=$2
    for i in $(seq 1 $lines); do
        echo "Line $i" >> "$file"
    done
}

create_binary_file() {
    dd if=/dev/zero bs=1024 count=1 of="$1" 2>/dev/null
}

create_zero_terminated_file() {
    local count=$1
    local file=$2
    for i in $(seq 1 $count); do
        printf "Record %d\0" "$i" >> "$file"
    done
}

create_large_file() {
    local lines=$1
    local file=$2
    for i in $(seq 1 $lines); do
        printf "This is line %d with some padding to make it longer................\n" "$i" >> "$file"
    done
}

assert_equal() {
    if [ "$1" != "$2" ]; then
        echo "Expected: $1"
        echo "Got: $2"
        return 1
    fi
    return 0
}

count_lines() {
    wc -l < "$1" | tr -d ' '
}

count_nulls() {
    tr -cd '\0' < "$1" | wc -c | tr -d ' '
}
