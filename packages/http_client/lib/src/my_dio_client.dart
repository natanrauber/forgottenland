import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_client/src/http_client_interface.dart';
import 'package:http_client/src/http_error_handler.dart';
import 'package:http_client/src/http_response.dart';

class MyDioClient implements IHttpClient {
  final Dio _dio = Dio(BaseOptions(headers: <String, dynamic>{'Content-Type': 'application/json'}));

  @override
  Future<MyHttpResponse> get(String path, {Map<String, dynamic>? headers}) async {
    return _request(() => _dio.get(path));
  }

  @override
  Future<MyHttpResponse> post(String path, dynamic data, {Map<String, dynamic>? headers}) async {
    return _request(() => _dio.post(path, data: data));
  }

  Future<MyHttpResponse> _request(Future<Response<dynamic>> Function() request) async {
    MyHttpResponse? response;
    try {
      response = MyHttpResponse.fromResponse(await request.call());
    } on DioError catch (e) {
      return HttpErrorHandler.dio(e);
    } on SocketException catch (e) {
      return HttpErrorHandler.socket(e);
    } catch (e) {
      return HttpErrorHandler.fallback(e);
    } finally {
      _printRequest(response);
    }
    return response;
  }

  void _printRequest(MyHttpResponse? response) => print(
        '${response?.requestOptions?.method} on "${response?.requestOptions?.baseUrl}${response?.requestOptions?.path}": ${response?.statusMessage} [${response?.statusCode}]',
      );
}
