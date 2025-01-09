import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage secureStorage;
  SecureStorageService({required this.secureStorage});

  Future<void> write({required String key, required String value}) async {
    debugPrint('$key : $value written to secure storage');
    await secureStorage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    debugPrint('$key read from secure storage');
    return await secureStorage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    debugPrint('$key deleted from secure storage');
    await secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    debugPrint('All keys deleted from secure storage');
    await secureStorage.deleteAll();
  }
}
