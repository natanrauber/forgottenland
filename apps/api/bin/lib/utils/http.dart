import 'dart:io';

import 'package:dio/dio.dart';

import 'handle_error.dart';
import 'paths.dart';

class CustomResponse {
  CustomResponse(this._response);

  final Response<dynamic>? _response;

  int? get statusCode => _response?.statusCode;

  String? get statusMessage => _response?.statusMessage;

  dynamic get data => _response?.data;

  RequestOptions? get requestOptions => _response?.requestOptions;

  Map<String, dynamic> get dataAsMap => _response?.data is Map<String, dynamic>
      ? _response?.data as Map<String, dynamic>
      : <String, dynamic>{};

  List<dynamic> get dataAsList =>
      _response?.data is List<dynamic> ? _response?.data as List<dynamic> : <dynamic>[];
}

class Http {
  factory Http() => _singleton;

  Http._internal() {
    _dio = Dio(getOptions());
  }

  static final Http _singleton = Http._internal();

  Dio _dio = Dio();

  BaseOptions getOptions() => BaseOptions(
        // connectTimeout: 10000,
        baseUrl: PATH.api,
      );

  /// print request properties
  static void printRequest(
    CustomResponse? response, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) =>
      print(
        '${response?.requestOptions?.method} on "${response?.requestOptions?.baseUrl}${response?.requestOptions?.path}": ${response?.statusMessage} [${response?.statusCode}]',
      );

  /// Handy method to make http [GET] request
  Future<CustomResponse?> get(String path) async {
    CustomResponse? response;

    try {
      response = CustomResponse(await _dio.get(path));
    } on DioError catch (e) {
      return HandleError.dio(e);
    } on SocketException catch (e) {
      HandleError.socket(e);
    } catch (e) {
      HandleError.fallback(e);
    } finally {
      printRequest(response);
    }

    return response ??
        CustomResponse(Response<dynamic>(requestOptions: RequestOptions(path: path)));
  }
}
