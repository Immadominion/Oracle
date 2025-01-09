import 'package:flutter/material.dart';
import 'package:oracle/core/constants/enum.dart';

class BaseChangeNotifier extends ChangeNotifier {
  BaseChangeNotifier();

  LoadingState _loadingState = LoadingState.idle;
  LoadingState get loadingState => _loadingState;
  set loadingState(LoadingState state) {
    _loadingState = state;
    notifyListeners();
  }

  // Other methods and properties can remain as needed for your application.
  void disposeControllers(List<ChangeNotifier> controllers) {
    for (var controller in controllers) {
      controller.dispose();
    }
  }
}
