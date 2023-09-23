import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

class ApiResponse extends Response {
  ApiResponse.success({dynamic data})
      : super(
          200,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": 'Success', "data": data}.clean()),
        );

  ApiResponse.accepted()
      : super(
          202,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": 'Accepted'}.clean()),
        );

  ApiResponse.noContent()
      : super(
          204,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": 'No Content'}.clean()),
        );

  ApiResponse.notFound()
      : super(
          404,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": 'Not Found'}.clean()),
        );

  ApiResponse.notAcceptable()
      : super(
          406,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": 'Not Acceptable'}.clean()),
        );

  ApiResponse.error(dynamic e)
      : super(
          500,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode({"server_time": MyDateTime.timeStamp(), "response": e.toString()}),
        );
}
