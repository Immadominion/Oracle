import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import * as llmService from '../services/llm.service.js';
import { EventEmitter } from 'events';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

class BatchManager extends EventEmitter {
  constructor(batchSize = 100) {
    super();
    this.BATCH_SIZE = batchSize;
    this.currentBatch = [];
    this.logsDir = path.join(__dirname, '../../logs');
    this.batchDir = path.join(this.logsDir, 'batches');
    this.aiResponseDir = path.join(this.logsDir, 'ai_responses');
    this.initializeDirectories();
  }

  async initializeDirectories() {
    try {
      await fs.mkdir(this.batchDir, { recursive: true });
      await fs.mkdir(this.aiResponseDir, { recursive: true });
    } catch (error) {
      console.error('Error initializing directories:', error);
      throw new Error('Failed to initialize required directories');
    }
  }

  async ensureDirectoryExists(dirPath) {
    try {
      await fs.access(dirPath);
    } catch {
      await fs.mkdir(dirPath, { recursive: true });
    }
  }

  async writeJsonFile(filePath, data) {
    try {
      await this.ensureDirectoryExists(path.dirname(filePath));
      await fs.writeFile(filePath, JSON.stringify(data, null, 2));
    } catch (error) {
      console.error(`Error writing to ${filePath}:`, error);
      throw error;
    }
  }

  async storeBatch(batch) {
    try {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const batchFilePath = path.join(this.batchDir, `batch_${timestamp}.json`);
      const batchData = { timestamp, tokens: batch };
      await this.writeJsonFile(batchFilePath, batchData);
      this.emit('batchStored', batch);
    } catch (error) {
      console.error('Error storing batch:', error);
      throw error;
    }
  }

  async storeAIResponse(response, originalBatch) {
    try {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const aiResponseFilePath = path.join(this.aiResponseDir, `ai_response_${timestamp}.json`);
      const aiResponseData = { timestamp, analysis: response };
      await this.writeJsonFile(aiResponseFilePath, aiResponseData);
      this.emit('aiResponseStored', response);
    } catch (error) {
      console.error('Error storing AI response:', error);
      throw error;
    }
  }

  async handleNewToken(tokenData) {
    try {
    //   console.log('handleNewToken called with:', tokenData);
      const enrichedToken = {
        ...tokenData,
        processed_timestamp: new Date().toISOString(),
        metadata: await this.fetchTokenMetadata(tokenData.uri)
      };

      this.currentBatch.push(enrichedToken);

      if (this.currentBatch.length >= this.BATCH_SIZE) {
        const batchToProcess = [...this.currentBatch];
        this.currentBatch = [];
        await this.processBatch(batchToProcess);
      }
    } catch (error) {
      console.error('Error handling new token:', error);
    }
  }

  async fetchTokenMetadata(uri) {
    try {
      if (!uri.startsWith('https://')) return null;
      const response = await fetch(uri);
      return await response.json();
    } catch {
      return null;
    }
  }

  async processBatch(batch) {
    try {
      console.log(`Processing batch of ${batch.length} tokens`);
      await this.storeBatch(batch);
      const aiResponse = await llmService.askOracleAI(batch);
      await this.storeAIResponse(aiResponse, batch);
      this.emit('batchProcessed', { batch, aiResponse });
    } catch (error) {
      console.error('Error processing batch:', error);
    }
  }
}

export const batchManager = new BatchManager();
export const handleNewToken = batchManager.handleNewToken.bind(batchManager);