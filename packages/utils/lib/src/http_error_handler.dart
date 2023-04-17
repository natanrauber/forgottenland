import 'dart:io';

import 'package:dio/dio.dart';
import 'package:utils/utils.dart';

class MyErrorHandler {
  /// [DioError] handler for [http] request
  static MyHttpResponse? dio(
    DioError e, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (e.response == null) {
      print(
        '${e.requestOptions.method} on "${e.requestOptions.baseUrl}${e.requestOptions.path}": ${e.message}',
      );
    } else {
      print(
        '${e.requestOptions.method} on "${e.requestOptions.baseUrl}${e.requestOptions.path}": ${e.response?.statusMessage} [${e.response?.statusCode}]',
      );
    }

    return MyHttpResponse.fromResponse(e.response);
  }

  /// [SocketException] handler for [http] request
  static void socket(
    SocketException e, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) =>
      print(e.message);

  /// [dynamic] error handler for [http] request when error type is neither [DioError] nor [SocketException]
  static void fallback(Object e) => print(e.toString());
}
