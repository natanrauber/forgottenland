import 'dart:io';

import 'package:dio/dio.dart';

import 'handle_error.dart';
import 'paths.dart';

class CustomResponse {
  CustomResponse({
    this.response,
    this.statusCode,
    this.statusMessage,
    this.data,
  });

  CustomResponse.fromResponse(this.response)
      : data = response?.data,
        statusCode = response?.statusCode,
        statusMessage = response?.statusMessage;

  final Response<dynamic>? response;
  final int? statusCode;
  final String? statusMessage;
  final dynamic data;

  bool get success => <int>[200, 201, 204].contains(statusCode);

  bool get hasData {
    if (data is Map<String, dynamic> || data is List<dynamic>) return true;
    return false;
  }

  Map<String, dynamic> get dataAsMap {
    if (data is Map<String, dynamic>) return data as Map<String, dynamic>;
    return <String, dynamic>{};
  }

  List<dynamic> get dataAsList {
    if (data is List<dynamic>) return data as List<dynamic>;
    return <dynamic>[];
  }

  RequestOptions? get requestOptions => response?.requestOptions;
}

class Http {
  factory Http() => _singleton;

  Http._internal() {
    _dio = Dio(getOptions());
  }

  static final Http _singleton = Http._internal();

  Dio _dio = Dio();

  BaseOptions getOptions() => BaseOptions(baseUrl: PATH.api);

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
  Future<CustomResponse> get(String path) async {
    CustomResponse? response;

    try {
      response = CustomResponse.fromResponse(await _dio.get(path));
    } on DioError catch (e) {
      HandleError.dio(e);
      return CustomResponse(statusCode: 500);
    } on SocketException catch (e) {
      HandleError.socket(e);
    } catch (e) {
      HandleError.fallback(e);
    } finally {
      printRequest(response);
    }

    return response ?? CustomResponse.fromResponse(Response<dynamic>(requestOptions: RequestOptions(path: path)));
  }
}
