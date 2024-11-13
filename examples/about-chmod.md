Here's how the unix "chmod" command behaves:

## Here's how chmod changes the file's mode:

```bash
$ chmod 644 file.txt
$ stat -c %A file.txt
-rw-r--r--
$ chmod u+x file.txt
$ stat -c %A file.txt
-rwxr--r--
$ chmod a+r file.txt
$ stat -c %A file.txt
-rwxr--r--
$ chmod g=wx file.txt
$ stat -c %A file.txt
-rwx-wx-r--
$ chmod 000 file.txt
$ stat -c %A file.txt
----------
$ chmod +x file.txt
$ stat -c %A file.txt
---x--x--x
$ mkdir directory
$ touch directory/file
$ chmod -R 755 directory
$ stat -c %A directory directory/file
drwxr-xr-x
-rwxr-xr-x
```

## Here's what some of those mode bits do:

```bash
$ echo "test data" > file.txt
$ chmod 000 file.txt
$ cat file.txt
cat: file.txt: Permission denied
$ chmod u+r file.txt
$ cat file.txt
test data
$ chmod 000 file.txt
$ echo "new data" > file.txt
-bash: file.txt: Permission denied
$ chmod u+w file.txt
$ echo "new data" > file.txt
$ mkdir dir
$ chmod 000 dir
$ cd dir
-bash: cd: dir: Permission denied
$ chmod u+x dir
$ cd dir
$ cd ..
$ chmod 000 dir
$ ls dir
ls: cannot open directory 'dir': Permission denied
$ chmod u+r dir
$ ls dir
file
$ rm dir/file
rm: cannot remove 'dir/file': Permission denied
$ chmod u+w dir
$ rm dir/file
$ rmdir dir
```