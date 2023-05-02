import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_client/src/http_response.dart';

class HttpErrorHandler {
  static MyHttpResponse dio(DioError e) {
    String output = '${e.requestOptions.method} on "${e.requestOptions.baseUrl}${e.requestOptions.path}": ';
    output += e.response == null ? '${e.message}' : '${e.response?.statusMessage} [${e.response?.statusCode}]';
    print(output);
    return MyHttpResponse.fromResponse(e.response);
  }

  static MyHttpResponse socket(SocketException e) {
    print(e.message);
    return MyHttpResponse(statusCode: 500);
  }

  static MyHttpResponse fallback(Object e) {
    print(e.toString());
    return MyHttpResponse(statusCode: 500);
  }
}
