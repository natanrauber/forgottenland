import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_client/src/http_client_interface.dart';
import 'package:http_client/src/http_response.dart';
import 'package:http_client/src/print_http_request.dart';

class MyDioClient implements IHttpClient {
  MyDioClient({BaseOptions? baseOptions, this.postRequestCallback, this.printResponseData = false}) {
    _dio = Dio(baseOptions ?? defaultBaseOptions);
  }

  late Dio _dio;
  final Function(MyHttpResponse response)? postRequestCallback;
  final bool printResponseData;

  static BaseOptions defaultBaseOptions = BaseOptions(
    headers: <String, dynamic>{'Content-Type': 'application/json'},
    sendTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    connectTimeout: Duration(seconds: 10),
  );

  @override
  Future<MyHttpResponse> get(String path, {Map<String, dynamic>? headers}) async {
    return _request(() => _dio.get(path, options: Options(headers: headers)));
  }

  @override
  Future<MyHttpResponse> post(String path, dynamic data, {Map<String, dynamic>? headers}) async {
    return _request(() => _dio.post(path, options: Options(headers: headers), data: data));
  }

  Future<MyHttpResponse> _request(Future<Response<dynamic>> Function() request) async {
    MyHttpResponse response = MyHttpResponse();

    try {
      response = MyHttpResponse.fromResponse(await request.call());
    } on DioException catch (e) {
      response = MyHttpResponse.fromResponse(e.response);
    } on SocketException catch (e) {
      response = MyHttpResponse(statusCode: 500, statusMessage: e.message);
    } catch (e) {
      response = MyHttpResponse(statusCode: 500, statusMessage: e.toString());
    }

    printRequest(response, printResponseData: printResponseData);
    postRequestCallback?.call(response);
    return response;
  }
}
