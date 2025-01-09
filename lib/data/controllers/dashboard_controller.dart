import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/data/controllers/base_controller.dart';
import 'package:oracle/data/local/secure_storage_service.dart';

final dashBoardControllerProvider = ChangeNotifierProvider<DashBoardController>(
  (ref) => DashBoardController(),
);

final SecureStorageService secureStorageService =
    SecureStorageService(secureStorage: const FlutterSecureStorage());

class DashBoardController extends BaseChangeNotifier {
  int page = 0;
  int get myPage => page;
  // ignore: prefer_final_fields
  bool _deviceHasInternet = true;
  bool get checkDeviceInternet => _deviceHasInternet;

  Future<String> getName() async {
    String? name = await secureStorageService.read(key: "name");
    List<String> part = name.toString().split(" ");
    name = part[0];
    return name;
  }

  Future<String> getImage() async {
    String? picture = await secureStorageService.read(key: "picture");
    return picture as String;
  }

  Future<String> getId() async {
    String? id = await secureStorageService.read(key: "id");
    return id as String;
  }

  void setPage(int num) {
    page = num;
    notifyListeners();
  }

  void setTwoPage() {
    page = 2;
    notifyListeners();
  }

  void switchPage(int index) {
    myPage = index;
  }

  set myPage(int index) {
    page = index;
    notifyListeners();
  }
}
