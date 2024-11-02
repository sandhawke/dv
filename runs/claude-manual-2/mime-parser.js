import { createInterface } from 'node:readline';
import debug from 'debug';

const log = {
  parser: debug('mime:parser'),
  boundary: debug('mime:boundary'),
  headers: debug('mime:headers'),
  content: debug('mime:content'),
  parts: debug('mime:parts')
};

export async function* parseMimeMultipart(stream) {
  const reader = createInterface({
    input: stream,
    crlfDelay: Infinity,
    terminal: false
  });
  
  let state = 'BEFORE_BOUNDARY';
  let boundary = null;
  let headers = {};
  let content = [];
  let isComplete = false;
  
  function resetPart() {
    headers = {};
    content = [];
  }
  
  function createPart() {
    const disposition = headers['content-disposition'] || '';
    const filenameMatch = disposition.match(/filename="([^"]+)"/i);
    const nameMatch = disposition.match(/name="([^"]+)"/i);
    
    const part = {
      headers: { ...headers },
      isBase64: (headers['content-transfer-encoding'] || '').toLowerCase() === 'base64',
      content: content.join('\n')
    };
    
    if (filenameMatch) {
      part.filename = filenameMatch[1];
    } else if (nameMatch) {
      part.filename = nameMatch[1];
    }
    
    log.parts('Created part:', part);
    return part;
  }
  
  for await (const rawLine of reader) {
    const line = rawLine.trimRight();
    log.parser('Processing line: [%s] (state: %s)', line, state);
    
    // Look for initial boundary
    if (!boundary) {
      if (line.startsWith('--') && !line.startsWith('----')) {
        boundary = line;
        state = 'HEADERS';
        resetPart();
        log.boundary('Found initial boundary: [%s]', boundary);
        continue;
      }
      continue;
    }
    
    // Handle boundaries
    if (line === boundary || line === boundary + '--') {
      log.boundary('Found boundary marker [%s] with header count: %d', line, Object.keys(headers).length);
      if (content.length > 0 || Object.keys(headers).length > 0) {
        const part = createPart();
        yield part;
      }
      
      if (line === boundary + '--') {
        isComplete = true;
        log.parser('End of archive');
        break;
      }
      
      state = 'HEADERS';
      resetPart();
      continue;
    }
    
    // Process headers
    if (state === 'HEADERS') {
      if (line === '') {
        log.headers('End of headers:', headers);
        state = 'CONTENT';
        continue;
      }
      
      const match = line.match(/^([^:]+):\s*(.*)$/);
      if (match) {
        const [, name, value] = match;
        headers[name.toLowerCase()] = value;
        log.headers('Found header: %s = %s', name.toLowerCase(), value);
      } else {
        log.headers('Skipping invalid header line: [%s]', line);
      }
      continue;
    }
    
    // Process content
    if (state === 'CONTENT') {
      log.content('Adding content line: [%s]', line);
      content.push(line);
    }
  }
  
  // Handle truncated archives
  if (!isComplete && (content.length > 0 || Object.keys(headers).length > 0)) {
    console.error('\x1b[31mWarning: Archive appears to be truncated\x1b[0m');
    const part = createPart();
    log.parser('Yielding truncated part');
    yield part;
  }
}
