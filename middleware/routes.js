const express = require('express');
const router = express.Router();
const { getRecentUpdates } = require('./bitqueryService');

router.get('/data', (req, res) => {
  res.send({ message: 'Protected data access granted.', userId: req.userId });
});

router.get('/recent-updates', (req, res) => {
  res.json(getRecentUpdates());
});

module.exports = router;
