import { WebSocket } from 'ws';
import { handleNewToken } from '../utils/batchHandler.js';
import dotenv from 'dotenv';
import { json } from 'express';

dotenv.config();

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
                  TokenSupplyUpdates {
                    TokenSupplyUpdate {
                      Currency {
                        Symbol
                        Name
                        Uri
                        Decimals
                        MintAddress
                        MetadataAddress
                        ProgramAddress
                        UpdateAuthority
                        VerifiedCollection
                        Wrapped
                      }
                      PostBalance
                      Amount
                    }
                  }
                }
              }
            `
          }
        }));
      } else if (response.type === 'data') {
        const updates = response.payload.data.Solana.TokenSupplyUpdates;

        console.log('--- New Bitquery Data ---');
        updates.forEach((update) => {
          // Log the complete update object
          console.log('Full Update Object:', JSON.stringify(update, null, 2));

          const formattedUpdate = {
            amount: update.TokenSupplyUpdate.PostBalance,
            symbol: update.TokenSupplyUpdate.Currency.Symbol,
            name: update.TokenSupplyUpdate.Currency.Name,
            uri: update.TokenSupplyUpdate.Currency.Uri || 'N/A',
            postBalance: update.TokenSupplyUpdate.PostBalance || 0,
            timestamp: new Date().toISOString()
          };

          // console.log('Formatted Update:', formattedUpdate); // Log the formatted version as well
          console.log('--- End of Update ---')

          recentUpdates.unshift(formattedUpdate);
          if (recentUpdates.length > MAX_STORED_UPDATES) {
            recentUpdates.pop();
          }

          broadcastData(formattedUpdate);
          handleNewToken(formattedUpdate);
          // handleNewToken(JSON.stringify(update, null, 2));
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

export default { startBitqueryStream, stopBitqueryStream, getRecentUpdates };