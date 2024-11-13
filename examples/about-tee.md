Here's how the unix "tee" command behaves:

```bash
$ echo "hello" | tee file.txt
hello
$ cat file.txt
hello
$ echo "world" | tee -a file.txt
world
$ cat file.txt
hello
world
$ echo "testing" | tee output1.txt output2.txt
testing
$ cat output1.txt
testing
$ cat output2.txt
testing
$ echo -n | tee empty.txt
$ cat empty.txt
$ (echo -n "no newline" | tee nonl.txt); echo '<nl>'
no newline<nl>
$ cat nonl.txt; echo '<nl>'
no newline<nl>
$ echo -e "line 1\nline 2" | tee lines.txt
line 1
line 2
$ cat lines.txt
line 1
line 2
```
