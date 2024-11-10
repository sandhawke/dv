# Loop Tools

Our environment has a set of "loop tools" which run after a set of changes are submitted by a software developer. They take special instructions from files in _from_developer/tool-request, providing a response in _to_developer/tool-response.

In general, each new request is made by creating a file like _from_developer/tool-request/$REQUEST_TITLE.json with contents like {"tool":"curl","purpose":"find a library to use for mime encoding","arguments":["https://registry.npmjs.org/-/v1/search?text=keywords:mime+encoding&size=25","-H","Accept: application/json"]}

## Standard properties

* `tool`: a tool name. If the named tool is not available, this request will be ignored. Generally a list of available tools will be provided.
* `purpose` English text explaining the value of running the tool to service this request. This text is essential for letting future engineers and systems know how to use the tool result when it is later provided

## Available Tools

### search-npmjs-com

Provides search of the standard NPM public repository, to help identify good libraries to build upon. Parameters accepted by [libnpmsearch](https://www.npmjs.com/package/libnpmsearch) may be available.

* `query`: the text to provide the npmjs.com search engine

### npm-docs

Provide access to the public documentation of an NPM package. Usually provides necessary information before using a package.

* `package-name`: the name as provided by search-npmjs-com, with the @namespace prefix if appropriate, and with an @version suffix if desired

### npm-source

Provide access to the public source code of an NPM package. Sometimes necessary to learn how to properly use a package.

* `package-name`: the name as provided by search-npmjs-com, with the @namespace prefix if appropriate, and with an @version suffix if desired

### curl

Provide general access to the web. Useful for checking information before making assumptions.

* `arguments`: array of arguments to the curl command line interface

