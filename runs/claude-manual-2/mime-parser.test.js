import { Readable } from 'node:stream';
import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { parseMimeMultipart } from './mime-parser.js';

async function collectParts(content) {
  // Ensure proper line endings in the input stream
  const stream = Readable.from(Buffer.from(content.replace(/\r?\n/g, '\n')));
  const parts = [];
  for await (const part of parseMimeMultipart(stream)) {
    parts.push(part);
  }
  return parts;
}

describe('parseMimeMultipart', () => {
  it('parses basic multipart with LF endings', async () => {
    const input = `--boundary
Content-Disposition: attachment; filename="test.txt"

Hello world!
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].filename, 'test.txt');
    assert.equal(parts[0].content, 'Hello world!');
  });

  it('parses basic multipart with CRLF endings', async () => {
    const input = `--boundary\r\nContent-Disposition: attachment; filename="test.txt"\r\n\r\nHello world!\r\n--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].filename, 'test.txt');
    assert.equal(parts[0].content, 'Hello world!');
  });

  it('handles multiple parts', async () => {
    const input = `--boundary
Content-Disposition: attachment; filename="1.txt"

First file
--boundary
Content-Disposition: attachment; filename="2.txt"

Second file
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 2);
    assert.equal(parts[0].filename, '1.txt');
    assert.equal(parts[0].content, 'First file');
    assert.equal(parts[1].filename, '2.txt');
    assert.equal(parts[1].content, 'Second file');
  });

  it('handles base64 encoded content', async () => {
    const input = `--boundary
Content-Disposition: attachment; filename="test.bin"
Content-Transfer-Encoding: base64

SGVsbG8gd29ybGQh
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].filename, 'test.bin');
    assert.equal(parts[0].isBase64, true);
  });

  it('handles form-data fields', async () => {
    const input = `--boundary
Content-Disposition: form-data; name="field1"

Value 1
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].filename, 'field1');
    assert.equal(parts[0].content, 'Value 1');
  });

  it('handles content with embedded dashes', async () => {
    const input = `--boundary
Content-Disposition: attachment; filename="test.txt"

This line --has-- dashes
Another --line-- here
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].content, 'This line --has-- dashes\nAnother --line-- here');
  });

  it('handles content with empty lines', async () => {
    const input = `--boundary
Content-Disposition: attachment; filename="test.txt"

Line 1

Line 2

Line 3
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].content, 'Line 1\n\nLine 2\n\nLine 3');
  });

  it('handles truncated archives', async () => {
    const input = `--boundary
Content-Disposition: attachment; filename="test.txt"

Content here but no closing boundary`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].filename, 'test.txt');
    assert.equal(parts[0].content, 'Content here but no closing boundary');
  });

  it('accepts name instead of filename', async () => {
    const input = `--boundary
Content-Disposition: attachment; name="test.txt"

Hello world!
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].filename, 'test.txt');
    assert.equal(parts[0].content, 'Hello world!');
  });

  it('preserves all headers', async () => {
    const input = `--boundary
Content-Disposition: attachment; filename="test.txt"
Content-Type: text/plain
Last-Modified: Wed, 21 Oct 2015 07:28:00 GMT
X-Custom-Header: custom value

Content
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts[0].headers['content-type'], 'text/plain');
    assert.equal(parts[0].headers['last-modified'], 'Wed, 21 Oct 2015 07:28:00 GMT');
    assert.equal(parts[0].headers['x-custom-header'], 'custom value');
  });

  it('handles missing content-disposition', async () => {
    const input = `--boundary
Content-Type: text/plain

Orphaned content
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].content, 'Orphaned content');
  });

  it('ignores content before first boundary', async () => {
    const input = `This should be ignored
More ignored content
--boundary
Content-Disposition: attachment; filename="test.txt"

Hello world!
--boundary--`;
    const parts = await collectParts(input);
    assert.equal(parts.length, 1);
    assert.equal(parts[0].filename, 'test.txt');
    assert.equal(parts[0].content, 'Hello world!');
  });
});
