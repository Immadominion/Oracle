const { WebSocketServer } = require('ws');
const { Server } = require('socket.io');
const { getRecentUpdates } = require('./bitqueryService');

let io;

function initSocketIO(server) {
  io = new Server(server);
  io.on('connection', (socket) => {
    console.log('Socket.IO client connected');
    socket.emit('initialData', getRecentUpdates());

    socket.on('disconnect', () => {
      console.log('Socket.IO client disconnected');
    });
  });
}

function initWebSocket(port) {
  const wss = new WebSocketServer({ port }, () => {
    console.log(`WebSocket server running on port ${port}`);
  });

  wss.on('connection', (ws) => {
    console.log('WebSocket client connected');
    ws.send(JSON.stringify({ message: 'Welcome to the WebSocket server!' }));

    ws.on('message', (message) => {
      console.log('Received WebSocket message:', message);
    });

    ws.on('close', () => {
      console.log('WebSocket client disconnected');
    });
  });
}

function broadcastUpdate(update) {
  if (io) {
    io.emit('tokenUpdate', update);
  }
}

module.exports = { initSocketIO, initWebSocket, broadcastUpdate };
