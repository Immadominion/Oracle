const { WebSocket } = require('ws');
require('dotenv').config();

let recentUpdates = [];
const MAX_STORED_UPDATES = 100;
let bitqueryConnection = null;

function getRecentUpdates() {
  return recentUpdates;
}

function startBitqueryStream(broadcastData) {
  if (bitqueryConnection && bitqueryConnection.readyState === WebSocket.OPEN) {
    console.log('Bitquery stream already active');
    return;
  }

  const token = process.env.BITQUERY_TOKEN;
  const endpoint = `wss://streaming.bitquery.io/eap?token=${token}`;
  bitqueryConnection = new WebSocket(endpoint, 'graphql-ws');

  bitqueryConnection.on('open', () => {
    console.log('Connected to Bitquery');
    bitqueryConnection.send(JSON.stringify({
      type: 'connection_init',
      payload: { token }
    }));
  });

  bitqueryConnection.on('message', (data) => {
    try {
      const response = JSON.parse(data);
      if (response.type === 'connection_ack') {
        bitqueryConnection.send(JSON.stringify({
          type: 'start',
          id: '1',
          payload: {
            query: `
              subscription {
                Solana {
                  TokenSupplyUpdates(
                    where: {Instruction: {Program: {Address: {is: "6EF8rrecthR5Dkzon8Nwu78hRvfCKubJ14M5uBEwF6P"}, Method: {is: "create"}}}}
                  ) {
                    TokenSupplyUpdate {
                      Amount
                      Currency {
                        Symbol
                        Name
                        MintAddress
                        Uri
                      }
                      PostBalance
                    }
                  }
                }
              }
            `
          }
        }));
      } else if (response.type === 'data') {
        const updates = response.payload.data.Solana.TokenSupplyUpdates;
        updates.forEach(update => {
          const formattedUpdate = {
            amount: update.TokenSupplyUpdate.Amount,
            symbol: update.TokenSupplyUpdate.Currency.Symbol,
            name: update.TokenSupplyUpdate.Currency.Name,
            mintAddress: update.TokenSupplyUpdate.Currency.MintAddress,
            uri: update.TokenSupplyUpdate.Currency.Uri,
            postBalance: update.TokenSupplyUpdate.PostBalance,
            timestamp: new Date().toISOString()
          };

          console.log('New token update:', formattedUpdate);

          recentUpdates.unshift(formattedUpdate);
          if (recentUpdates.length > MAX_STORED_UPDATES) {
            recentUpdates.pop();
          }

          broadcastData(formattedUpdate);
        });
      }
    } catch (err) {
      console.error('Error handling Bitquery data:', err);
    }
  });

  bitqueryConnection.on('error', (err) => {
    console.error('Bitquery connection error:', err);
  });
}

function stopBitqueryStream() {
  if (bitqueryConnection) {
    bitqueryConnection.close();
    console.log('Bitquery stream stopped');
  }
}

module.exports = { startBitqueryStream, stopBitqueryStream, getRecentUpdates };