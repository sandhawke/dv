import test from 'node:test'
import { strict as assert } from 'node:assert'
import { add } from '../src/example-file.js'

// A minimal example of a node-native test. Delete this file once other
// tests have been written.

test('example test', t => {
  assert.strictEqual(add(1, 2), 3)
})
