# Loop Tools

Our environment has a set of "loop tools" which run after a set of changes are submitted by a software developer. They take special instructions from files in _from_developer/tool-request, providing a response in _to_developer/tool-response.

In general, each new request is made by creating a file like _from_developer/tool-request/$REQUEST_TITLE.json with contents like {"tool":"curl","purpose":"find a library to use for mime encoding","arguments":["https://registry.npmjs.org/-/v1/search?text=keywords:mime+encoding&size=25","-H","Accept: application/json"]}

## Standard properties

* `tool`: a tool name. If the named tool is not available, this request will be ignored. Generally a list of available tools will be provided.
* `purpose` English text explaining the value of running the tool to service this request. This text is essential for letting future engineers and systems know how to use the tool result when it is later provided

## Available Tools

### curl

Provide general access to the web

* `arguments`: array of arguments to the curl command line interface

