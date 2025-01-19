import express from 'express';
import http from 'http';
import { WebSocketServer } from 'ws'; // Correct import for WebSocketServer
import bitqueryService from './src/services/bitqueryService.js';
import { batchManager } from './src/utils/batchHandler.js';
import routes from './src/routes/routes.js';

const app = express();
const server = http.createServer(app);
const wss = new WebSocketServer({ server });
const PORT = process.env.PORT || 8080;

class WebSocketManager {
  constructor() {
    this.clients = new Set();
  }

  addClient(ws) {
    this.clients.add(ws);
    console.log(`Client connected. Total clients: ${this.clients.size}`);
  }

  removeClient(ws) {
    this.clients.delete(ws);
    console.log(`Client disconnected. Total clients: ${this.clients.size}`);
  }

  broadcast(data) {
    for (const client of this.clients) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(data));
      }
    }
  }
}

const wsManager = new WebSocketManager();

wss.on('connection', (ws) => {
  wsManager.addClient(ws);

  // Send recent updates to new client
  const recentUpdates = bitqueryService.getRecentUpdates();
  ws.send(JSON.stringify({ type: 'history', data: recentUpdates }));

  if (wsManager.clients.size === 1) {
    bitqueryService.startBitqueryStream(data => wsManager.broadcast(data));
  }

  ws.on('close', () => {
    wsManager.removeClient(ws);
    if (wsManager.clients.size === 0) {
      bitqueryService.stopBitqueryStream();
    }
  });
});

bitqueryService.startBitqueryStream(data => wsManager.broadcast(data));

// Listen for batch events
batchManager.on('batchProcessed', ({ batch, aiResponse }) => {
  wsManager.broadcast({
    type: 'batchAnalysis',
    data: { batch, aiResponse }
  });
});

app.use(express.json());
app.use('/api', routes);

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});