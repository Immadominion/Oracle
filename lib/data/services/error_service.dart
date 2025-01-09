import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oracle/utils/locator.dart';

import '../local/toast_service.dart';

final ErrorService errorService = locator<ErrorService>();

class ErrorService {
  String timeoutMessage = 'Timeout. Please, try again.';
  String defaultErrorMessage = 'Something went wrong! please try again later';

  static void handleErrors(dynamic e) {
    String message = '';
    if (e is String) {
      // Handle string error messages
      message = e;
    } else if (e is Map) {
      // Handle map error messages
      if (e['errors'] != null) {
        message = e['errors'][0]['message'];
        locator<ToastService>().showErrorToast(
          message,
        );
      } else if (e['message'] != null) {
        message = e['message'];
        locator<ToastService>().showErrorToast(
          message,
        );
      } else {
        message = errorService.defaultErrorMessage;
        locator<ToastService>().showErrorToast(
          message,
        );
        debugPrint('${e.toString()} Things 000');
      }
    } else if (e is TimeoutException) {
      // Handle timeout errors
      message = errorService.timeoutMessage;
      locator<ToastService>().showErrorToast(
        message,
      );
    } else if (e is Error) {
      // Handle general errors
      message = errorService.defaultErrorMessage;
      locator<ToastService>().showErrorToast(
        e.toString(),
      );
      debugPrint('${e.runtimeType} Things 001');
      debugPrint('${e.toString()} This is the error o!');
      debugPrint('${e.stackTrace} This is the error o!');
      debugPrint('$e This is the error o!');
    } else if (e is Exception) {
      // Handle general exceptions
      message = errorService.defaultErrorMessage;
      locator<ToastService>().showErrorToast(
        message,
      );
      debugPrint('${e.toString()} Things 002');
    } else if (e is FormatException) {
      // Handle formatting errors
      message = 'There is something wrong with the format.';
      locator<ToastService>().showErrorToast(
        message,
      );
    } else if (e is JsonUnsupportedObjectError) {
      // Handle JSON parsing errors
      message = 'There is something wrong with the JSON format.';
      locator<ToastService>().showErrorToast(
        message,
      );
    } else {
      // Handle other types of errors
      message = errorService.defaultErrorMessage;
      locator<ToastService>().showErrorToast(
        message,
      );
      debugPrint('${e.toString()} Things 004');
    }
    debugPrint('ERROR MESSAGE : ${e.toString()} : $message Things 004');
    // Show error message using a toast widget
    locator<ToastService>().showErrorToast(
      message,
    );
  }
}
