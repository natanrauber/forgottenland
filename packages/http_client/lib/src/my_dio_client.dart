import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_client/src/http_client_interface.dart';
import 'package:http_client/src/http_error_handler.dart';
import 'package:http_client/src/http_response.dart';

class MyDioClient implements IHttpClient {
  MyDioClient({BaseOptions? baseOptions, this.postRequestCallback}) {
    _dio = Dio(baseOptions ?? defaultBaseOptions);
  }

  late Dio _dio;
  final Function(MyHttpResponse? response, Object? e)? postRequestCallback;

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
    MyHttpResponse? response;
    try {
      response = MyHttpResponse.fromResponse(await request.call());
    } on DioException catch (e) {
      postRequestCallback?.call(MyHttpResponse.fromResponse(e.response), null);
      return HttpErrorHandler.dio(e);
    } on SocketException catch (e) {
      postRequestCallback?.call(null, e);
      return HttpErrorHandler.socket(e);
    } catch (e) {
      postRequestCallback?.call(null, e);
      return HttpErrorHandler.fallback(e);
    } finally {
      if (response != null) {
        _printRequest(response);
        postRequestCallback?.call(response, null);
      }
    }
    return response;
  }

  void _printRequest(MyHttpResponse? response) => print(
        '${response?.requestOptions?.method} on "${response?.requestOptions?.baseUrl}${response?.requestOptions?.path}": ${response?.statusMessage} [${response?.statusCode}]',
      );
}
