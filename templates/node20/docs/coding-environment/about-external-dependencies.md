# Details of External Dependencies

External dependencies which are not widely known should include some of their documentation in the docs/external-dependencies directory. Searches for candidate dependencies can also go here.

To request a search of npmjs:

* Create a file with a unique descriptive name, starting search-, like docs/external-dependencies/search-log-file-handler

* In the file put lines defining the variables "SEARCH" and "PURPOSE", like:

```
SEARCH=log
PURPOSE=We have a requirement to log major events and errors, and there may be logging libraries that solve this well.
```

In response, a file named response-..., like docs/external-dependencies/response-log-file-handler should be produced in due course by system tools.

When you see a completed search results, you may delete them and replace them with a summary of what was found. It should be complete and clear enough that future developers have everything they need, and no need to run another search.

