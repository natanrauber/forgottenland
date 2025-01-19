import 'package:http_client/http_client.dart';
import 'package:utils/utils.dart';

void printRequest(MyHttpResponse response, {bool printResponseData = false}) {
  String method = '${response.requestOptions?.method}';
  String endpoint = _getRelativePath(response.requestOptions?.path);
  String statusMessage = ': ${response.response?.statusMessage}';
  if ((response.response?.statusMessage ?? '').isEmpty) statusMessage = '';
  String statusCode = '${response.statusCode}';
  String request = '[$statusCode] $method on "$endpoint"$statusMessage';

  if (response.error) {
    customPrint(request, color: PrintColor.red);
    if (printResponseData) customPrint(response.dataAsMap, type: PrintType.json, color: PrintColor.yellow);
    return;
  }

  if (response.success) {
    customPrint(request, color: PrintColor.green);
    if (printResponseData) customPrint(response.dataAsMap, type: PrintType.json, color: PrintColor.yellow);
    return;
  }

  customPrint(request, color: PrintColor.yellow);
  if (printResponseData) customPrint(response.dataAsMap, type: PrintType.json, color: PrintColor.yellow);
}

String _getRelativePath(String? path) {
  if (path == null) return 'null';
  String a = path.split('://').last;
  String b = a.split('/').first;
  if (b.length <= 9) return a;
  return a.replaceAll(b, '${b.substring(0, 9)}...');
}
