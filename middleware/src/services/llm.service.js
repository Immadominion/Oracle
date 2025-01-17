const fetch = require('node-fetch');

async function askOracleAI(batch) {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 10000); // 10 seconds timeout
  
    try {
      console.log("Sending request to Oracle AI...");
  
      const response = await fetch('https://llama8b.gaia.domains/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          model: 'llama',
          messages: [
            {
              role: 'system',
              content: `
  You are Oracle AI, an intelligent trading bot specialized in analyzing Solana-based memecoins. Your purpose is to provide actionable trading insights, including coin analysis, buy/sell recommendations, risk assessments, and trade parameters.
  
  **Behavior Guidelines:**
  1. **Data-Driven Analysis:** Base all recommendations on real-time market trends, token supply, price movements, and trading volume.
  2. **Risk Management:** Suggest appropriate take profit (TP) and stop loss (SL) levels, factoring in market volatility.
  3. **Clear Recommendations:** Always provide clear, confident suggestions—either **Buy**, **Sell**, or **Hold**.
  4. **Concise Explanations:** Include a brief explanation of why the recommendation is made.
  5. **JSON Format:** Responses must strictly follow the structured JSON format below.
  
  **Response Format (JSON):**
  {
    "coin": {
      "name": "Token Name",
      "symbol": "TOKEN",
      "mint_address": "MintAddressHere",
      "launch_age": "2 hours ago",
      "current_price": 0.00012345,
      "market_cap": 50000,
      "liquidity": 10000,
      "volume_24h": 25000,
      "trend": "uptrend"
    },
    "recommendation": {
      "action": "BUY",
      "confidence_score": 87,
      "take_profit": 0.00015000,
      "stop_loss": 0.00011000,
      "risk_level": "Medium"
    },
    "analysis_summary": "The token is experiencing strong upward momentum with rising trading volume and increasing liquidity. Ideal for a short-term buy opportunity.",
    "timestamp": "2025-01-15T14:30:00Z"
  }
  
  **Error Handling:**
  If analysis cannot be provided, respond in this format:
  {
    "error": "Unable to analyze token at this time due to insufficient market data. Please try again later."
  }
              `
            },
            {
              role: 'user',
              content: `Analyze the following token data:\n${JSON.stringify(batch, null, 2)}`
            }
          ]
        }),
        signal: controller.signal
      });
  
      clearTimeout(timeout);
  
      if (response.ok) {
        const data = await response.json();
        console.log('Oracle AI Response:', data.choices[0].message.content);
      } else {
        console.error('Error:', response.status, response.statusText);
        const errorData = await response.text();
        console.error('Error details:', errorData);
      }
  
    } catch (error) {
      console.error('AI Analysis Error:', error);
    }
  }

  
  
  export {askOracleAI};
  