#!/bin/bash

# Test behavior when filesystem is full
# Note: This test requires root privileges to use mount

if [ "$EUID" -ne 0 ]; then
    echo "Skipping filesystem full test (requires root)"
    exit 0
fi

# Create and mount a small filesystem
dd if=/dev/zero of=small_fs.img bs=1M count=1
mkfs.ext2 small_fs.img
mkdir mnt
mount small_fs.img mnt

# Fill the filesystem
dd if=/dev/zero of=mnt/bigfile bs=1M count=1
test_file="mnt/test.txt"

# Attempt to touch a file
$COMMAND "$test_file"
result=$?

umount mnt
rm -f small_fs.img

[ $result -eq 1 ] || exit 1
