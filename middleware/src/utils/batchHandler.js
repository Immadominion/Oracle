const fs = require('fs');
const path = require('path');
const llmService = require('../services/llm.service');

const BATCH_SIZE = 100;
let currentBatch = [];

const batchFilePath = path.join(__dirname, '../../logs/batches.json');
const aiResponsePath = path.join(__dirname, '../../logs/ai_responses.json');

function storeBatch(batch) {
  const existingData = fs.existsSync(batchFilePath) ? JSON.parse(fs.readFileSync(batchFilePath)) : [];
  existingData.push(batch);
  fs.writeFileSync(batchFilePath, JSON.stringify(existingData, null, 2));
}

function storeAIResponse(response) {
  const existingData = fs.existsSync(aiResponsePath) ? JSON.parse(fs.readFileSync(aiResponsePath)) : [];
  existingData.push(response);
  fs.writeFileSync(aiResponsePath, JSON.stringify(existingData, null, 2));
}

async function handleNewToken(tokenData) {
  currentBatch.push(tokenData);

  if (currentBatch.length >= BATCH_SIZE) {
    storeBatch([...currentBatch]);

    // Send batch to Oracle AI
    const aiResponse = await llmService.analyzeBatch(currentBatch);
    storeAIResponse(aiResponse);

    currentBatch = []; // Reset batch
  }
}

module.exports = { handleNewToken, storeBatch, storeAIResponse };
