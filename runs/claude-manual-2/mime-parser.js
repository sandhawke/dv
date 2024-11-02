import { createInterface } from 'node:readline';

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
    
    return part;
  }
  
  for await (const rawLine of reader) {
    console.log(`Processing line: [${rawLine}] (state: ${state})`);
    const line = rawLine.trimRight();
    
    // Look for initial boundary
    if (!boundary) {
      if (line.startsWith('--') && !line.startsWith('----')) {
        console.log(`Found initial boundary: [${line}]`);
        boundary = line;
        state = 'HEADERS';
        resetPart();
        continue;
      }
      continue;
    }
    
    // Handle boundaries
    if (line === boundary || line === boundary + '--') {
      console.log(`Found boundary marker [${line}] with header count: ${Object.keys(headers).length}`);
      if (content.length > 0 || Object.keys(headers).length > 0) {
        const part = createPart();
        console.log('Yielding part:', JSON.stringify(part, null, 2));
        yield part;
      }
      
      if (line === boundary + '--') {
        isComplete = true;
        break;
      }
      
      state = 'HEADERS';
      resetPart();
      continue;
    }
    
    // Process headers
    if (state === 'HEADERS') {
      if (line === '') {
        console.log('End of headers:', headers);
        state = 'CONTENT';
        continue;
      }
      
      const match = line.match(/^([^:]+):\s*(.*)$/);
      if (match) {
        const [, name, value] = match;
        headers[name.toLowerCase()] = value;
        console.log(`Found header: ${name.toLowerCase()} = ${value}`);
      } else {
        console.log(`Skipping invalid header line: [${line}]`);
      }
      continue;
    }
    
    // Process content
    if (state === 'CONTENT') {
      console.log(`Adding content line: [${line}]`);
      content.push(line);
    }
  }
  
  // Handle truncated archives
  if (!isComplete && (content.length > 0 || Object.keys(headers).length > 0)) {
    console.error('\x1b[31mWarning: Archive appears to be truncated\x1b[0m');
    const part = createPart();
    console.log('Yielding truncated part:', JSON.stringify(part, null, 2));
    yield part;
  }
}
