Look over the state of this software project and define the next sprint.

Create a file called team-notes/sprint.md that specifies exactly what code should be created in the next round of work. Describe any new modules and changes to existing modules. Describe how to approach the unit tests, integration tests, and command line tests (cltests) that will assure us the new code is functioning correctly.

The new code should be scoped to be quite small, as small a coherent improvement as you can specify. At most, it needs to be something you can implement easily, and which a senior software engineer could easily write and debug in 1-2 hours.

You may write some additional cltests now which will show off the results of the sprint.

Create or update test-this-sprint.sh as a narrowed-down version of test-all.sh to run cltest with, as its arguments, just the cltest files which demonstrate the new functionality to be added this sprint. This file may include unit and integration tests as well if they are useful in this sprint.
