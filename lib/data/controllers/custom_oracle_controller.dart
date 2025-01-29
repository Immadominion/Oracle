import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomOracleSettings {
  // Oracle Base Configuration
  String baseOracleName;
  bool isCustomFromScratch;

  // Oracle Identity
  String oracleName;
  String oracleBio;

  // Trading Parameters
  double riskReward;
  bool isLongTerm;
  String tradingStrategy;
  double entryPrice;

  // Financial Settings
  double averageTradeAmount;
  double targetWalletBalance;
  double stopLossPercentage;

  // Market Restrictions
  double minMarketCap;
  double maxMarketCap;

  // Tracking Options
  List<String> customWallets;
  List<String> trackedTwitterPages;
  List<String> customCapabilities;

  CustomOracleSettings({
    this.baseOracleName = '',
    this.isCustomFromScratch = true,
    this.oracleName = '',
    this.oracleBio = '',
    this.riskReward = 2.0,
    this.isLongTerm = true,
    this.tradingStrategy = '',
    this.entryPrice = 0.001,
    this.averageTradeAmount = 0.0,
    this.targetWalletBalance = 0.0,
    this.stopLossPercentage = 0.0,
    this.minMarketCap = 0.0,
    this.maxMarketCap = double.infinity,
    this.customWallets = const [],
    this.trackedTwitterPages = const [],
    this.customCapabilities = const [],
  });

  CustomOracleSettings copyWith({
    String? baseOracleName,
    bool? isCustomFromScratch,
    String? oracleName,
    String? oracleBio,
    double? riskReward,
    bool? isLongTerm,
    String? tradingStrategy,
    double? entryPrice,
    double? averageTradeAmount,
    double? targetWalletBalance,
    double? stopLossPercentage,
    double? minMarketCap,
    double? maxMarketCap,
    List<String>? customWallets,
    List<String>? trackedTwitterPages,
    List<String>? customCapabilities,
  }) {
    return CustomOracleSettings(
      baseOracleName: baseOracleName ?? this.baseOracleName,
      isCustomFromScratch: isCustomFromScratch ?? this.isCustomFromScratch,
      oracleName: oracleName ?? this.oracleName,
      oracleBio: oracleBio ?? this.oracleBio,
      riskReward: riskReward ?? this.riskReward,
      isLongTerm: isLongTerm ?? this.isLongTerm,
      tradingStrategy: tradingStrategy ?? this.tradingStrategy,
      entryPrice: entryPrice ?? this.entryPrice,
      averageTradeAmount: averageTradeAmount ?? this.averageTradeAmount,
      targetWalletBalance: targetWalletBalance ?? this.targetWalletBalance,
      stopLossPercentage: stopLossPercentage ?? this.stopLossPercentage,
      minMarketCap: minMarketCap ?? this.minMarketCap,
      maxMarketCap: maxMarketCap ?? this.maxMarketCap,
      customWallets: customWallets ?? this.customWallets,
      trackedTwitterPages: trackedTwitterPages ?? this.trackedTwitterPages,
      customCapabilities: customCapabilities ?? this.customCapabilities,
    );
  }
}

class CustomOracleController extends Notifier<CustomOracleSettings> {
  @override
  CustomOracleSettings build() => CustomOracleSettings();

  void setBaseOracle(String oracleName) {
    state = state.copyWith(
      baseOracleName: oracleName,
      isCustomFromScratch: false,
    );
    _populateFromBaseOracle(oracleName);
  }

  void _populateFromBaseOracle(String oracleName) {
    switch (oracleName) {
      case 'Mommy':
        state = state.copyWith(
          riskReward: 4.5,
          isLongTerm: false,
          tradingStrategy: 'Aggressive Scalping',
        );
        break;
      case 'Normie':
        state = state.copyWith(
          riskReward: 3.0,
          isLongTerm: false,
          tradingStrategy: 'Swing Trading',
        );
        break;
      case 'Whale':
        state = state.copyWith(
          riskReward: 2.0,
          isLongTerm: true,
          tradingStrategy: 'Value Investing',
        );
        break;
      case 'Meggalodon':
        state = state.copyWith(
          riskReward: 1.5,
          isLongTerm: true,
          tradingStrategy: 'Capital Preservation',
        );
        break;
    }
  }

  void updateOracleIdentity({String? name, String? bio}) {
    state = state.copyWith(
      oracleName: name ?? state.oracleName,
      oracleBio: bio ?? state.oracleBio,
    );
  }

  void updateTradingParameters({
    double? riskReward,
    bool? isLongTerm,
    String? tradingStrategy,
    double? entryPrice,
  }) {
    state = state.copyWith(
      riskReward: riskReward,
      isLongTerm: isLongTerm,
      tradingStrategy: tradingStrategy,
      entryPrice: entryPrice,
    );
  }

  void updateFinancialSettings({
    double? averageTradeAmount,
    double? targetWalletBalance,
    double? stopLossPercentage,
  }) {
    state = state.copyWith(
      averageTradeAmount: averageTradeAmount,
      targetWalletBalance: targetWalletBalance,
      stopLossPercentage: stopLossPercentage,
    );
  }

  void updateMarketRestrictions({
    double? minMarketCap,
    double? maxMarketCap,
  }) {
    state = state.copyWith(
      minMarketCap: minMarketCap,
      maxMarketCap: maxMarketCap,
    );
  }

  void addCustomWallet(String wallet) {
    final updatedWallets = [...state.customWallets, wallet];
    state = state.copyWith(customWallets: updatedWallets);
  }

  void removeCustomWallet(String wallet) {
    final updatedWallets = state.customWallets.where((w) => w != wallet).toList();
    state = state.copyWith(customWallets: updatedWallets);
  }

  void addTrackedTwitterPage(String page) {
    final updatedPages = [...state.trackedTwitterPages, page];
    state = state.copyWith(trackedTwitterPages: updatedPages);
  }

  void removeTrackedTwitterPage(String page) {
    final updatedPages = state.trackedTwitterPages.where((p) => p != page).toList();
    state = state.copyWith(trackedTwitterPages: updatedPages);
  }

  void addCustomCapability(String capability) {
    final updatedCapabilities = [...state.customCapabilities, capability];
    state = state.copyWith(customCapabilities: updatedCapabilities);
  }

  void removeCustomCapability(String capability) {
    final updatedCapabilities = state.customCapabilities.where((c) => c != capability).toList();
    state = state.copyWith(customCapabilities: updatedCapabilities);
  }
}

final customOracleControllerProvider = NotifierProvider<CustomOracleController, CustomOracleSettings>(
  () => CustomOracleController(),
);