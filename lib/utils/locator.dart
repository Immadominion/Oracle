import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:oracle/data/local/secure_storage_service.dart';
import 'package:oracle/data/local/toast_service.dart';
import 'package:oracle/data/services/error_service.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  const sharedPreferences = FlutterSecureStorage();
  locator.registerSingleton(sharedPreferences);

  locator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(
      secureStorage: locator(),
    ),
  );

  locator.registerLazySingleton<ErrorService>(
    () => ErrorService(),
  );

  locator.registerLazySingleton<ToastService>(
    () => ToastService(),
  );
}
