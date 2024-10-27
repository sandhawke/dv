#!/usr/bin/env node

import { Command } from 'commander';
import Anthropic from '@anthropic-ai/sdk';
import fs from 'fs-extra';
import path from 'path';
import { spawn } from 'child_process';
import { createInterface } from 'readline';
import { pipeline } from 'stream/promises';

const DEFAULT_MODEL = 'claude-3-5-sonnet-latest';
const DEFAULT_MAX_TOKENS = 8000;

// Utility functions
const formatError = (error) => ({
  timestamp: new Date().toISOString(),
  message: error.message,
  code: error.code,
  type: error.error?.type,
  stack: error.stack,
  details: error.error || null
});

const truncateString = (str, length = 60) => 
  str.length > length ? `${str.substring(0, length)}...` : str;

// Configuration management
class Config {
  constructor() {
    this.configDir = process.env.LLPIPE_CONFIG || path.join(process.cwd(), '.llpipe');
    this.historyDir = path.join(this.configDir, 'history');
    this.systemPromptFile = path.join(this.configDir, 'system-prompt.txt');
    
    // Ensure directories exist
    fs.ensureDirSync(this.configDir);
    fs.ensureDirSync(this.historyDir);
  }

  async getSystemPrompt() {
    try {
      if (await fs.pathExists(this.systemPromptFile)) {
        const content = await fs.readFile(this.systemPromptFile, 'utf8');
        return content.trim();
      }
    } catch (error) {
      console.error('Warning: Error reading system prompt:', error.message);
    }
    return null;
  }

  async getNextHistoryId() {
    try {
      const files = await fs.readdir(this.historyDir);
      const ids = files
        .map(f => parseInt(f))
        .filter(n => !isNaN(n));
      return (Math.max(0, ...ids) + 1).toString();
    } catch (error) {
      return '1';
    }
  }

  async getLatestHistoryId() {
    try {
      const files = await fs.readdir(this.historyDir);
      const ids = files
        .map(f => parseInt(f))
        .filter(n => !isNaN(n));
      return ids.length > 0 ? Math.max(...ids).toString() : null;
    } catch (error) {
      return null;
    }
  }

  historyPath(id) {
    return path.join(this.historyDir, id);
  }

  validateHistoryId(id) {
    const numId = parseInt(id);
    if (isNaN(numId) || numId < 1 || String(numId) !== id) {
      throw new Error(`Invalid history ID: ${id}`);
    }
    return id;
  }
}

// History management
class HistoryManager {
  constructor(config) {
    this.config = config;
  }

  async loadMessages(historyId) {
    try {
      this.config.validateHistoryId(historyId);
      const messagesFile = path.join(this.config.historyPath(historyId), 'messages.json');
      if (await fs.pathExists(messagesFile)) {
        const data = await fs.readFile(messagesFile, 'utf8');
        return JSON.parse(data);
      }
      throw new Error(`History ID ${historyId} not found`);
    } catch (error) {
      console.error(`Warning: Error loading history ${historyId}:`, error.message);
      return null;
    }
  }

  async saveMessages(historyId, messages, metadata = {}) {
    const historyPath = this.config.historyPath(historyId);
    await fs.ensureDir(historyPath);
    
    const meta = {
      timestamp: new Date().toISOString(),
      model: DEFAULT_MODEL,
      maxTokens: DEFAULT_MAX_TOKENS,
      messageCount: messages.messages.length,
      systemPromptUsed: messages.messages[0]?.role === 'system',
      ...metadata
    };

    await Promise.all([
      fs.writeJson(path.join(historyPath, 'messages.json'), messages, { spaces: 2 }),
      fs.writeJson(path.join(historyPath, 'meta.json'), meta, { spaces: 2 })
    ]);
  }

  async saveError(historyId, error) {
    const historyPath = this.config.historyPath(historyId);
    await fs.ensureDir(historyPath);
    await fs.writeJson(
      path.join(historyPath, 'error.json'),
      formatError(error),
      { spaces: 2 }
    );
  }

  async listHistory() {
    const files = await fs.readdir(this.config.historyDir);
    const histories = [];
    
    for (const id of files.sort((a, b) => parseInt(a) - parseInt(b))) {
      try {
        const [messages, meta] = await Promise.all([
          this.loadMessages(id),
          fs.readJson(path.join(this.config.historyPath(id), 'meta.json')).catch(() => null)
        ]);

        if (messages) {
          const lastUserMessage = messages.messages
            .filter(m => m.role === 'user')
            .pop();
            
          histories.push({
            id,
            timestamp: meta?.timestamp || 'Unknown',
            exchanges: messages.messages.length,
            preview: lastUserMessage ? truncateString(lastUserMessage.content) : '',
            model: meta?.model || DEFAULT_MODEL
          });
        }
      } catch (error) {
        console.error(`Warning: Error loading history ${id}:`, error.message);
      }
    }
    
    return histories;
  }
}

// LLM interaction
class LLMClient {
  constructor() {
    const anthropicKey = process.env.ANTHROPIC_API_KEY;
    const openaiKey = process.env.OPENAI_API_KEY;
    
    if (!anthropicKey && !openaiKey) {
      throw new Error(
        'Neither ANTHROPIC_API_KEY nor OPENAI_API_KEY environment variables are set.\n' +
        'Please set one of these environment variables to use llpipe.'
      );
    }
    
    if (anthropicKey) {
      this.client = new Anthropic({ apiKey: anthropicKey });
    } else {
      throw new Error('OpenAI support not yet implemented');
    }
  }

  async getResponse(messages) {
    if (process.env.LLPIPE_INNER) {
      return await this.getFromInnerCommand(messages);
    } else {
      return await this.getFromLLM(messages);
    }
  }

  async getFromLLM(messages) {
    try {
      const response = await this.client.messages.create({
        model: DEFAULT_MODEL,
        max_tokens: DEFAULT_MAX_TOKENS,
        messages: messages.messages
      });
      
      if (!response.content || response.content.length === 0) {
        throw new Error('Empty response from LLM');
      }

      const text = response.content[0].text;
      process.stdout.write(text);
      return text;

    } catch (error) {
      if (error.error?.type === 'rate_limit_error') {
        const retryAfter = error.error?.retry_after || 60;
        const retryDate = new Date(Date.now() + retryAfter * 1000);
        console.error(
          `Rate limit reached. Waiting ${retryAfter} seconds.\n` +
          `Will resume at ${retryDate.toLocaleTimeString()}`
        );
        await new Promise(resolve => setTimeout(resolve, retryAfter * 1000));
        return await this.getFromLLM(messages);
      }
      throw error;
    }
  }

  async getFromInnerCommand(messages) {
    return new Promise((resolve, reject) => {
      const child = spawn(process.env.LLPIPE_INNER, { shell: true });
      let output = '';
      
      child.stdout.on('data', (data) => {
        const text = data.toString();
        process.stdout.write(text);
        output += text;
      });
      
      child.stderr.on('data', (data) => {
        console.error(`Inner command error: ${data}`);
      });
      
      child.on('close', (code) => {
        if (code === 0) {
          resolve(output);
        } else {
          reject(new Error(`Inner command failed with code ${code}`));
        }
      });
      
      child.stdin.write(JSON.stringify(messages));
      child.stdin.end();
    });
  }
}

// Main program
async function main() {
  const program = new Command();
  
  program
    .name('llpipe')
    .description('CLI tool for interacting with LLM APIs')
    .version('1.0.0')
    .option('--after <historyId>', 'continue after specified history ID')
    .option('--more', 'continue after most recent history')
    .option('--new', 'start new conversation')
    .option('--list', 'list conversation history')
    .option('--pull <historyId>', 'output response from specified history ID')
    .parse(process.argv);

  const options = program.opts();
  const config = new Config();
  const history = new HistoryManager(config);
  let newHistoryId = null;
  
  try {
    // Handle --list option
    if (options.list) {
      const histories = await history.listHistory();
      if (histories.length === 0) {
        console.log('No conversation history found.');
        return;
      }
      console.table(histories);
      return;
    }
    
    // Handle --pull option
    if (options.pull) {
      const messages = await history.loadMessages(options.pull);
      if (!messages) {
        throw new Error(`History ID ${options.pull} not found`);
      }
      const response = messages.messages.find(m => m.role === 'assistant');
      if (response) {
        process.stdout.write(response.content);
      } else {
        throw new Error(`No assistant response found in history ${options.pull}`);
      }
      return;
    }
    
    // Read user input from stdin
    const rl = createInterface({
      input: process.stdin,
      output: process.stdout,
      terminal: false
    });
    
    let userInput = '';
    for await (const line of rl) {
      userInput += line + '\n';
    }
    userInput = userInput.trim();
    
    if (!userInput) {
      throw new Error('No input provided on stdin');
    }

    // Prepare messages array
    const messages = { messages: [] };
    
    // Add system prompt if exists and not --new
    const systemPrompt = await config.getSystemPrompt();
    if (systemPrompt && !options.new) {
      messages.messages.push({
        role: 'system',
        content: systemPrompt
      });
    }
    
    // Add history messages if requested
    if (!options.new) {
      let historyId = options.after;
      if (options.more) {
        historyId = await config.getLatestHistoryId();
        if (!historyId) {
          console.error('Warning: No previous history found, starting new conversation');
        }
      }
      if (historyId) {
        const historyMessages = await history.loadMessages(historyId);
        if (historyMessages) {
          messages.messages.push(...historyMessages.messages);
        } else {
          throw new Error(`Could not load history ${historyId}`);
        }
      }
    }
    
    // Add current user message
    messages.messages.push({
      role: 'user',
      content: userInput
    });
    
    // Get next history ID and create LLM client
    newHistoryId = await config.getNextHistoryId();
    const llm = new LLMClient();
    
    // Get response and save history
    const response = await llm.getResponse(messages);
    
    messages.messages.push({
      role: 'assistant',
      content: response
    });
    
    await history.saveMessages(newHistoryId, messages, {
      inputLength: userInput.length,
      responseLength: response.length,
      sourceHistoryId: options.after || (options.more ? await config.getLatestHistoryId() : null)
    });
    
  } catch (error) {
    console.error('Error:', error.message);
    if (newHistoryId) {
      await history.saveError(newHistoryId, error);
    }
    process.exit(1);
  }
}

main().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
