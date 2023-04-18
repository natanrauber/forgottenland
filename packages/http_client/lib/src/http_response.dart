import 'package:dio/dio.dart';

class MyHttpResponse {
  MyHttpResponse({
    this.response,
    this.statusCode,
    this.statusMessage,
    this.data,
  });

  MyHttpResponse.fromResponse(this.response)
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
