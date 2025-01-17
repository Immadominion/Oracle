const express = require('express');
const fs = require('fs');
const path = require('path');
const router = express.Router();
const { getRecentUpdates } = require('../services/bitqueryService');

const aiResponsePath = path.join(__dirname, '../../logs/ai_responses.json');

router.get('/data', (req, res) => {
  res.send({ message: 'Protected data access granted.', userId: req.userId });
});

router.get('/recent-updates', (req, res) => {
  res.json(getRecentUpdates());
});

router.get('/ai-recommendations', (req, res) => {
  if (fs.existsSync(aiResponsePath)) {
    const data = JSON.parse(fs.readFileSync(aiResponsePath));
    res.json(data);
  } else {
    res.status(404).json({ message: 'No AI recommendations available yet.' });
  }
});

module.exports = router;
