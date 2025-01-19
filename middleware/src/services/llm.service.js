import fetch from 'node-fetch';

async function askOracleAI(batch) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 1000000);

  try {
    console.log("Sending request to Oracle AI...");
    

    // const response = await fetch('https://llama8b.gaia.domains/v1/chat/completions', {
    const response = await fetch('https://llama3b.gaia.domains/v1/chat/completions', {
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
      return data.choices[0].message.content; // Return the AI response
    } else {
      console.error('Error:', response.status, response.statusText);
      const errorData = await response.text();
      console.error('Error details:', errorData);
      return { error: 'Error fetching AI response' };
    }

  } catch (error) {
    console.error('AI Analysis Error:', error);
    return { error: 'AI Analysis Error' };
  }
}

export { askOracleAI };


// import fetch from 'node-fetch';
// import dotenv from 'dotenv';

// dotenv.config();

// const GOOGLE_API_KEY = process.env.GOOGLE_API_KEY;

// async function askOracleAI(batch) {
//   try {
//     console.log("Sending request to Gemini API...");

//     const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GOOGLE_API_KEY}`, {
//       method: 'POST',
//       headers: {
//         'Content-Type': 'application/json'
//       },
//       body: JSON.stringify({
//         contents: [
//           {
//             parts: [
//               {
//                 text: `
// You are Oracle AI, an intelligent trading bot specialized in analyzing Solana-based memecoins. Your purpose is to provide actionable trading insights, including coin analysis, buy/sell recommendations, risk assessments, and trade parameters.

// **Behavior Guidelines:**
// 1. **Data-Driven Analysis:** Base all recommendations on real-time market trends, token supply, price movements, and trading volume.
// 2. **Risk Management:** Suggest appropriate take profit (TP) and stop loss (SL) levels, factoring in market volatility.
// 3. **Clear Recommendations:** Always provide clear, confident suggestions—either **Buy**, **Sell**, or **Hold**.
// 4. **Concise Explanations:** Include a brief explanation of why the recommendation is made.
// 5. **JSON Format:** Responses must strictly follow the structured JSON format below.

// **Response Format (JSON):**
// {
//   "coin": {
//     "name": "Token Name",
//     "symbol": "TOKEN",
//     "mint_address": "MintAddressHere",
//     "launch_age": "2 hours ago",
//     "current_price": 0.00012345,
//     "market_cap": 50000,
//     "liquidity": 10000,
//     "volume_24h": 25000,
//     "trend": "uptrend"
//   },
//   "recommendation": {
//     "action": "BUY",
//     "confidence_score": 87,
//     "take_profit": 0.00015000,
//     "stop_loss": 0.00011000,
//     "risk_level": "Medium"
//   },
//   "analysis_summary": "The token is experiencing strong upward momentum with rising trading volume and increasing liquidity. Ideal for a short-term buy opportunity.",
//   "timestamp": "2025-01-15T14:30:00Z"
// }



// Analyze the following token data:\n${JSON.stringify(batch, null, 2)}
//                 `
//               }
//             ]
//           }
//         ]
//       })
//     });

//     if (response.ok) {
//       const data = await response.json();
//       console.log('Gemini API Response:', data.candidates[0].content.parts[0].text);
//       return data.candidates[0].content.parts[0].text;
//     } else {
//       console.error('Error:', response.status, response.statusText);
//       const errorData = await response.text();
//       console.error('Error details:', errorData);
//       return { error: 'Error fetching AI response' };
//     }
//   } catch (error) {
//     console.error('AI Analysis Error:', error);
//     return { error: 'AI Analysis Error' };
//   }
// }

// export { askOracleAI };
