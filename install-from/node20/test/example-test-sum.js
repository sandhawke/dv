import test from 'node:test'
import { strict as assert } from 'node:assert'

import { add } from '../src/example-file.js'

// A minimal example of a node-native test.

test('example test', t => {
  assert.strictEqual(add(1, 2), 3)
  assert.strictEqual(add(0, -1), -1)
})
