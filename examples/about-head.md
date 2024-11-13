Here's how the unix "head" command behaves:

```bash
$ echo -e "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12" > lines.txt
$ head lines.txt
1
2
3
4
5
6
7
8
9
10
$ echo -e "1\n2\n3" | head
1
2
3
$ echo -n | head
$ echo -n "no newline" | head
no newline$ head -3 lines.txt
1
2
3
$ echo -e "1\n2\n3\n4\n5" | head -2
1
2
$ head nonexistent.txt lines.txt
==> nonexistent.txt <==
head: nonexistent.txt: No such file or directory

==> lines.txt <==
1
2
3
4
5
6
7
8
9
10
$ echo "piped" | head lines.txt -
==> lines.txt <==
1
2
3
4
5
6
7
8
9
10

==> standard input <==
piped
```

