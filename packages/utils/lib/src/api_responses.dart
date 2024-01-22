import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

final Map<String, dynamic> defaultBody = <String, dynamic>{
  "server_time": DT.germany.timeStamp(),
  "tibia_time": DT.tibia.timeStamp(),
};

class ApiResponse extends Response {
  ApiResponse.success({dynamic data})
      : super(
          200,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode(
            defaultBody.map((key, value) => MapEntry(key, value))
              ..addAll({"response": 'Success', "data": data})
              ..clean(),
          ),
        );

  ApiResponse.accepted()
      : super(
          202,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode(
            defaultBody.map((key, value) => MapEntry(key, value))
              ..addAll({"response": 'Accepted'})
              ..clean(),
          ),
        );

  ApiResponse.noContent()
      : super(
          204,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode(
            defaultBody.map((key, value) => MapEntry(key, value))
              ..addAll({"response": 'No Content'})
              ..clean(),
          ),
        );

  ApiResponse.notFound()
      : super(
          404,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode(
            defaultBody.map((key, value) => MapEntry(key, value))
              ..addAll({"response": 'Not Found'})
              ..clean(),
          ),
        );

  ApiResponse.notAcceptable()
      : super(
          406,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode(
            defaultBody.map((key, value) => MapEntry(key, value))
              ..addAll({"response": 'Not Acceptable'})
              ..clean(),
          ),
        );

  ApiResponse.error(dynamic e)
      : super(
          500,
          headers: <String, Object>{"Content-Type": "application/json"},
          body: jsonEncode(
            defaultBody.map((key, value) => MapEntry(key, value))
              ..addAll({"response": e.toString()})
              ..clean(),
          ),
        );
}
