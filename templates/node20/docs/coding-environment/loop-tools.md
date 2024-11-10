# Loop Tools

Our environment has a set of "loop tools" which run after a set of changes are submitted by a software developer. They take special instructions from files in _from_developer/tool-request, providing a response in _to_developer/tool-response.

In general, each new request is made by creating a file like _from_developer/tool-request/$REQUEST_TITLE.json with contents like {"tool":"curl","purpose":"find out if the website example.com answers http GET requests so that ...[details]","arguments":["http://example.com"]}.

## Standard properties

* `tool`: a tool name. If the named tool is not available, this request will be ignored. Generally a list of available tools will be provided.
* `purpose` English text explaining the value of running the tool to service this request. This text is essential for letting future engineers and systems know how to use the tool result when it is later provided

## Available Tools

### search-npmjs-com

Provides access to the standard NPM public repository. Parameters accepted by [libnpmsearch](https://www.npmjs.com/package/libnpmsearch) may be available.

* `query`: the text to provide the npmjs.com search engine

### npm-docs

Provide access to the public documentation of an NPM package.

* `package-name`: the name as provided by search-npmjs-com, with the @namespace prefix if appropriate, and with an @version suffix if desired

### npm-source

Provide access to the public source code of an NPM package

* `package-name`: the name as provided by search-npmjs-com, with the @namespace prefix if appropriate, and with an @version suffix if desired

### curl

Provide general access to the web

* `arguments`: array of arguments to the curl command line interface

