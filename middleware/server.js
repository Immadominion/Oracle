const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const dotenv = require('dotenv');
const bitqueryService = require('./bitqueryService');

dotenv.config();

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

const PORT = process.env.PORT || 8080;

let clients = [];

wss.on('connection', (ws) => {
  console.log('New WebSocket client connected');
  clients.push(ws);

  if (clients.length === 1) {
    bitqueryService.startBitqueryStream(broadcastData);
  }

  ws.on('close', () => {
    console.log('WebSocket client disconnected');
    clients = clients.filter(client => client !== ws);

    if (clients.length === 0) {
      bitqueryService.stopBitqueryStream();
    }
  });
});

function broadcastData(data) {
  clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(data));
    }
  });
}

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
