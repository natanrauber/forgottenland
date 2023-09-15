import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

class ApiResponseSuccess extends Response {
  ApiResponseSuccess({dynamic data})
      : super.ok(
          jsonEncode({"server_time": MyDateTime.timeStamp(), "response": 'Success', "data": data}.clean()),
          headers: <String, Object>{"Content-Type": "application/json"},
        );
}

class ApiResponseAccepted extends Response {
  ApiResponseAccepted({dynamic data})
      : super(
          202,
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": 'Accepted', "data": data}.clean()),
          headers: <String, Object>{"Content-Type": "application/json"},
        );
}

class ApiResponseNoContent extends Response {
  ApiResponseNoContent({dynamic data})
      : super(
          204,
          headers: <String, Object>{"Content-Type": "application/json"},
        );
}

class ApiResponseError extends Response {
  ApiResponseError(dynamic e)
      : super.internalServerError(
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": e.toString()}),
          headers: <String, Object>{"Content-Type": "application/json"},
        );
}
