import 'oracle_buddy_card.dart';

List<OracleCapability> getCapabilitiesForOracle(String oracleName) {
  // Define specific capabilities for each oracle
  switch (oracleName) {
    case 'Mommy':
      return [
        OracleCapability(name: 'Real-time Market Data', isActive: true),
        OracleCapability(name: 'Custom GPT Access', isActive: true),
        OracleCapability(name: 'Twitter Scanner', isActive: true),
        OracleCapability(name: 'Aggressive Trend Tracking', isActive: true),
        OracleCapability(name: 'Memecoin Shill Detection', isActive: true),
        OracleCapability(name: 'Whale Wallet Checks', isActive: true),
        OracleCapability(name: 'High-Risk Strategy Alerts', isActive: true),
        OracleCapability(name: 'Pump Potential Analysis', isActive: true),
      ];
    case 'Normie':
      return [
        OracleCapability(name: 'Real-time Market Data', isActive: true),
        OracleCapability(name: 'Custom GPT Access', isActive: false),
        OracleCapability(name: 'Twitter Scanner', isActive: true),
        OracleCapability(name: 'Mid-Cap Tracking', isActive: true),
        OracleCapability(name: 'Swing Trade Alerts', isActive: true),
        OracleCapability(name: 'Telegram Channel Checks', isActive: false),
        OracleCapability(name: 'Technical Analysis', isActive: true),
        OracleCapability(name: 'Market Sentiment Analysis', isActive: true),
      ];
    case 'Whale':
      return [
        OracleCapability(name: 'Real-time Market Data', isActive: true),
        OracleCapability(name: 'Advanced Portfolio Analysis', isActive: true),
        OracleCapability(name: 'Long-Term Trend Tracking', isActive: true),
        OracleCapability(
            name: 'Institutional Investor Insights', isActive: true),
        OracleCapability(name: 'Fundamental Analysis', isActive: true),
        OracleCapability(name: 'Risk Mitigation Strategies', isActive: true),
        OracleCapability(name: 'Blue-Chip Asset Scanning', isActive: true),
        OracleCapability(name: 'Global Market Correlation', isActive: true),
      ];
    case 'Meggalodon':
      return [
        OracleCapability(name: 'Real-time Market Data', isActive: true),
        OracleCapability(name: 'Stablecoin Performance', isActive: true),
        OracleCapability(name: 'Low-Volatility Asset Tracking', isActive: true),
        OracleCapability(name: 'Yield Farming Optimization', isActive: true),
        OracleCapability(name: 'Risk Management', isActive: true),
        OracleCapability(name: 'Capital Preservation Alerts', isActive: true),
        OracleCapability(
            name: 'Diversification Recommendations', isActive: true),
        OracleCapability(name: 'Passive Income Strategies', isActive: true),
      ];
    default:
      return [];
  }
}
