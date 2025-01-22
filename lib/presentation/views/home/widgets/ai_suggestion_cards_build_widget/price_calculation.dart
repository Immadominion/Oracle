extension PriceCalculations on double {
  double calculateProfit(double investment, double entryPrice) {
    return (this - entryPrice) * investment / entryPrice;
  }
}