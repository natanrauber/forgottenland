import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'datetime.dart';

class ResponseSuccess extends Response {
  ResponseSuccess({dynamic data})
      : super.ok(
          jsonEncode(
            {
              "server_time": MyDateTime.timeStamp(),
              "response": 'ok',
              if (data != null) "data": data,
            },
          ),
          headers: <String, Object>{
            "Content-Type": "application/json",
          },
        ) {
    print('success');
  }
}

class ResponseError extends Response {
  ResponseError(dynamic e)
      : super.internalServerError(
          body: jsonEncode(
            {
              "server_time": MyDateTime.timeStamp(),
              "response": e.toString(),
            },
          ),
          headers: <String, Object>{"Content-Type": "application/json"},
        ) {
    print('error $e');
  }
}
