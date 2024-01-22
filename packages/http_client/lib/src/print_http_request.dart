import 'package:http_client/http_client.dart';
import 'package:utils/utils.dart';

void printRequest(MyHttpResponse response, {bool printResponseData = false}) {
  String method = '${response.requestOptions?.method}';
  String endpoint = '${response.requestOptions?.baseUrl}${response.requestOptions?.path}';
  String statusMessage = '${response.response?.statusMessage}';
  String statusCode = '${response.statusCode}';
  String request = '>> $method on "$endpoint": $statusMessage [$statusCode]';

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
