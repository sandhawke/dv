Install the library from NPM:

npm install js-tiktoken

Usage

Basic usage follows, which includes all the OpenAI encoders and ranks:

import assert from "node:assert";
import { getEncoding, encodingForModel } from "js-tiktoken";

const enc = getEncoding("gpt2");
assert(enc.decode(enc.encode("hello world")) === "hello world");