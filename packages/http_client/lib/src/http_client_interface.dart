import 'package:http_client/src/http_response.dart';

abstract class IHttpClient {
  Future<MyHttpResponse> get(String path, {Map<String, dynamic>? headers});
  Future<MyHttpResponse> post(String path, dynamic data, {Map<String, dynamic>? headers});
}
