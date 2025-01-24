import 'dart:convert';

List<dynamic> getData() {
  String jsonString = '''
  [
    {
      "ticker": "SAMO",
      "launchDate": "2021-06-01",
      "aiAnalysis": "Strong potential due to active community engagement.",
      "chartData": [
        {
          "date": "2024-01-01",
          "value": 0.04
        },
        {
          "date": "2024-01-02",
          "value": 0.05
        }
      ],
      "socials": {},
      "currentPrice": 0.047
    },
    {
      "ticker": "KIN",
      "launchDate": "2017-09-26",
      "aiAnalysis": "Steady growth with utility in app ecosystems.",
      "chartData": [
        {
          "date": "2024-01-01",
          "value": 0.0001
        },
        {
          "date": "2024-01-02",
          "value": 0.0002
        }
      ],
      "socials": {},
      "currentPrice": 0.00015
    },
    {
      "ticker": "CHEEMS",
      "launchDate": "2022-04-15",
      "aiAnalysis": "Highly volatile with a strong meme factor.",
      "chartData": [
        {
          "date": "2024-01-01",
          "value": 0.001
        },
        {
          "date": "2024-01-02",
          "value": 0.0012
        }
      ],
      "socials": {},
      "currentPrice": 0.0011
    },
    {
      "ticker": "FIDA",
      "launchDate": "2020-12-03",
      "aiAnalysis": "Good fundamentals with recent upward momentum.",
      "chartData": [
        {
          "date": "2024-01-01",
          "value": 0.3
        },
        {
          "date": "2024-01-02",
          "value": 0.35
        }
      ],
      "socials": {},
      "currentPrice": 0.33
    },
    {
      "ticker": "SHBLZ",
      "launchDate": "2023-03-01",
      "aiAnalysis": "Community-driven and highly speculative.",
      "chartData": [
        {
          "date": "2024-01-01",
          "value": 0.002
        },
        {
          "date": "2024-01-02",
          "value": 0.0025
        }
      ],
      "socials": {},
      "currentPrice": 0.0023
    },
    {
      "ticker": "BONK",
      "launchDate": "2023-01-01",
      "aiAnalysis": "Massive pump due to meme appeal and low entry price.",
      "chartData": [
        {
          "date": "2024-01-01",
          "value": 0.00001
        },
        {
          "date": "2024-01-02",
          "value": 0.00002
        }
      ],
      "socials": {},
      "currentPrice": 0.000015
    },
    {
      "ticker": "GRAPE",
      "launchDate": "2021-09-01",
      "aiAnalysis": "Steady community-driven growth with recent traction.",
      "chartData": [
        {
          "date": "2024-01-01",
          "value": 0.07
        },
        {
          "date": "2024-01-02",
          "value": 0.075
        }
      ],
      "socials": {},
      "currentPrice": 0.072
    },
    {
      "ticker": "HAMS",
      "launchDate": "2023-06-15",
      "aiAnalysis": "Rapid growth in a niche audience.",
      "chartData": [
        {
          "date": "2024-01-01",
          "value": 0.005
        },
        {
          "date": "2024-01-02",
          "value": 0.006
        }
      ],
      "socials": {},
      "currentPrice": 0.0055
    }
  ]
  ''';

  List<dynamic> data = jsonDecode(jsonString);
  return data;
}


