Files here starting with '@bash' will have the rest of the line evaluated by bash, in the PROJECT_ROOT directory, subject to certain security restrictions.

Typical commands to run are 'mv', 'cp', 'rm', for when you see attached files that are similar to how they need to be, but not quite right.

For example, maybe you're working in python and you decide the file you see attached as main.py should be moved to src/main.py. You can just attach a new file in team-notes with the content '@bash mkdir -p src; mv main.py src/main.py'. This is much more efficient than sending a new copy of main.py with a new name.
