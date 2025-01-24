import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/data/controllers/base_controller.dart';
import 'package:oracle/data/local/secure_storage_service.dart';

final chooseOracleControllerProvider =
    ChangeNotifierProvider<ChooseOracleController>(
  (ref) => ChooseOracleController(),
);

final SecureStorageService secureStorageService =
    SecureStorageService(secureStorage: const FlutterSecureStorage());

class ChooseOracleController extends BaseChangeNotifier {
  int selectedIndex = 0;
  double riskReward = 2.0;
  bool isLongTerm = true;
  double entryPrice = 0.001;

  int get mySelectedIndex => selectedIndex;
  double get myRiskReward => riskReward;
  bool get myIsLongTerm => isLongTerm;
  double get myEntryPrice => entryPrice;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    debugPrint(
        '------------------------------------ User Selected Oracle index: $selectedIndex ------------------------------------');
    notifyListeners();
  }

  void setRiskReward(double value) {
    riskReward = value;
    debugPrint(
        '------------------------------------ User Selected Risk Reward: $riskReward ------------------------------------');
    notifyListeners();
  }

  void setIsLongTerm(bool value) {
    isLongTerm = value;
    debugPrint(
        '------------------------------------ User Selected Long Term: $isLongTerm ------------------------------------');
    notifyListeners();
  }

  void setEntryPrice(double value) {
    entryPrice = value;
    debugPrint(
        '------------------------------------ User Selected Entry Price: $entryPrice ------------------------------------');
    notifyListeners();
  }
}
