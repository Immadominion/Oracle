// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:oracle/core/constants/env_strings.dart';
import 'package:oracle/data/local/toast_service.dart';
import 'package:oracle/utils/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/env_api_constants.dart';

mixin DioMixin {
  Dio connect({Map<String, dynamic>? customHeaders}) {
    BaseOptions options = BaseOptions(
      baseUrl: 'wss://streaming.bitquery.io/eap?token=$apiKey',
      connectTimeout: const Duration(seconds: 200),
      receiveTimeout: const Duration(seconds: 200),
      responseType: ResponseType.json,
    );

    Dio dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString(Certify.token);

          if (token != 'token' && token != null) {
            options.headers['Authorization'] = "Bearer $token";
            log("This is the token value ==> $token");
          }
          if (customHeaders != null) {
            options.headers.addAll(Map<String, dynamic>.from(customHeaders));
          }
          return handler.next(options);
        },
        onError: (DioError e, handler) {
          debugPrint('DioError Type: $e');
          String errorMessage = _extractErrorMessage(e);
          if (errorMessage == 'Unauthenticated') {
            debugPrint('User is not authenticated');
          } else if (errorMessage == '') {
            // No specific message, handle default case
          } else {
            locator<ToastService>().showErrorToast(
              errorMessage,
            );
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }

  Future<Response<dynamic>> sendRequest(
      Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return response;
    } on DioError catch (e) {
      String message = e.message.toString();
      message = _extractErrorMessage(e);
      if (message == '') {
        // Handle any generic error
      } else if (message.toLowerCase() == 'unauthenticated') {
        debugPrint('User is unauthenticated');
      } else {
        debugPrint('User is unauthenticated 002 ==> $message');
        locator<ToastService>().showErrorToast(
          message,
        );
      }
      log('Dio Error 01: $e', error: e);

      rethrow;
    } catch (e) {
      log('Dio Error 02: $e', error: e);
      rethrow;
    }
  }
}

String _extractErrorMessage(DioError e) {
  String errorMessage = '';

  try {
    // Here you could parse the error message from the response if necessary
    if (kDebugMode) {
      print(e.response.toString());
    }
  } catch (error) {
    log('Error extracting error message: $error');
  }

  return errorMessage;
}
