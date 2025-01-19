import express from 'express';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import bitqueryService from '../services/bitqueryService.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const router = express.Router();
const aiResponsePath = path.join(__dirname, '../../logs/ai_responses.json');

router.get('/recent-updates', (_, res) => {
  res.json(bitqueryService.getRecentUpdates());
});

router.get('/ai-recommendations', (_, res) => {
  if (fs.existsSync(aiResponsePath)) {
    const data = JSON.parse(fs.readFileSync(aiResponsePath));
    res.json(data);
  } else {
    res.status(404).json({ message: 'No AI recommendations available yet.' });
  }
});

export default router;
