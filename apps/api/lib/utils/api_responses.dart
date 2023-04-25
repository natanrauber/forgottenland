import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

class ApiResponseSuccess extends Response {
  ApiResponseSuccess({dynamic data})
      : super.ok(
          jsonEncode({"server_time": MyDateTime.timeStamp(), "response": 'ok', "data": data}.clean()),
          headers: <String, Object>{"Content-Type": "application/json"},
        ) {
    print('success');
  }
}

class ApiResponseError extends Response {
  ApiResponseError(dynamic e)
      : super.internalServerError(
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": e.toString()}),
          headers: <String, Object>{"Content-Type": "application/json"},
        ) {
    print('error $e');
  }
}
