import 'package:dio/dio.dart' show Response;
import 'dio_mixin.dart';

class LoginService with DioMixin {
  ///To log user in
  Future<Response<dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };
    // Use the configured Dio instance from the mixin
    final response = await connect(customHeaders: customHeaders).post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  Future<Response<dynamic>> getUserInformation() async {
    final customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };
    // Use the configured Dio instance from the mixin
    final response = await connect(customHeaders: customHeaders).get(
      '/me',
    );
    return response;
  }
}
