import 'dart:io';

import 'package:dio/dio.dart';
import 'package:utils/src/http/http_response.dart';
import 'package:utils/src/http_error_handler.dart';

class MyHttpClient {
  factory MyHttpClient() => _singleton;

  MyHttpClient._internal() {
    _dio = Dio(getOptions());
  }

  static final MyHttpClient _singleton = MyHttpClient._internal();

  Dio _dio = Dio();

  BaseOptions getOptions() => BaseOptions(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        },
      );

  /// print request properties
  static void printRequest(
    MyHttpResponse? response, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) =>
      print(
        '${response?.requestOptions?.method} on "${response?.requestOptions?.baseUrl}${response?.requestOptions?.path}": ${response?.statusMessage} [${response?.statusCode}]',
      );

  /// Handy method to make http [GET] request
  Future<MyHttpResponse> get(String path) async {
    MyHttpResponse? response;

    try {
      response = MyHttpResponse.fromResponse(await _dio.get(path));
    } on DioError catch (e) {
      MyErrorHandler.dio(e);
      return MyHttpResponse(statusCode: 500);
    } on SocketException catch (e) {
      MyErrorHandler.socket(e);
    } catch (e) {
      MyErrorHandler.fallback(e);
    } finally {
      printRequest(response);
    }

    return response ?? MyHttpResponse.fromResponse(Response<dynamic>(requestOptions: RequestOptions(path: path)));
  }

  Future<MyHttpResponse> post(String path, dynamic data) async {
    MyHttpResponse? response;

    try {
      response = MyHttpResponse.fromResponse(await _dio.post(path, data: data));
    } on DioError catch (e) {
      MyErrorHandler.dio(e);
      return MyHttpResponse(statusCode: 500);
    } on SocketException catch (e) {
      MyErrorHandler.socket(e);
    } catch (e) {
      MyErrorHandler.fallback(e);
    } finally {
      printRequest(response);
    }

    return response ?? MyHttpResponse.fromResponse(Response<dynamic>(requestOptions: RequestOptions(path: path)));
  }
}
