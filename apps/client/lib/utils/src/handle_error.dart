// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:forgottenland/utils/utils.dart';

class HandleError {
  /// [DioError] handler for [http] request
  static Response<dynamic>? dio(
    DioError e, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (e.response == null) {
      customPrint(
        '${e.requestOptions.method} on "${e.requestOptions.baseUrl}${e.requestOptions.path}": ${e.message}',
        data: <String, dynamic>{
          'headers': headers,
          'body': body,
        },
      );
    } else {
      customPrint(
        '${e.requestOptions.method} on "${e.requestOptions.baseUrl}${e.requestOptions.path}": ${e.response?.statusMessage} [${e.response?.statusCode}]',
        data: <String, dynamic>{
          'headers': headers,
          'body': body,
          'response': e.response?.data,
        },
      );
    }
    return e.response;
  }

  /// [SocketException] handler for [http] request
  static void socket(
    SocketException e, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) =>
      customPrint(e.message);

  /// [dynamic] error handler for [http] request when error type is neither [DioError] nor [SocketException]
  static void fallback(Object e) => customPrint(e.toString());
}
