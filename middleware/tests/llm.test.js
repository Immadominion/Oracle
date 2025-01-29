import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { askOracleAI } from '../src/services/llm.service.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// const sampleBatchFilePath = path.join(__dirname, '../logs/batches/batch_2025-01-18T04-35-46-534Z.json');
const sampleBatchFilePath = path.join(__dirname, '../logs/batches/batch_2025-01-29T13-22-14-442Z.json');

async function testAskOracleAI() {
  try {
    const fileContent = await fs.readFile(sampleBatchFilePath, 'utf8');
    const sampleBatch = JSON.parse(fileContent).tokens; // Extract the batch data
    // console.log('Sample batch:', sampleBatch);
    const response = await askOracleAI(sampleBatch);
    console.log('AI Response:', response);
  } catch (error) {
    console.error('Error testing askOracleAI:', error);
  }
}

testAskOracleAI();