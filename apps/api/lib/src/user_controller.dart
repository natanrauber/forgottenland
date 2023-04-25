import 'dart:convert';

import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/api_responses.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

class UserController {
  Future<Response> login(Request request) async {
    try {
      var requestData = jsonDecode(await request.readAsString());
      var email = requestData['email'];
      var password = requestData['password'];
      var device = requestData['device'];
      var codec = utf8.fuse(base64);
      String sid = codec.encode({'email': email, 'device': device, 'datetime': MyDateTime.timeStamp()}.toString());
      String token = utf8.fuse(base64).encode('Basic $email:$password');
      List<dynamic> response = await DatabaseClient().from('account').select().eq('secret', token);

      if (response.isEmpty) return ApiResponseError('Invalid credentials');

      var account = response.first;
      var values = {'id': sid, 'account_id': account['id']};
      await DatabaseClient().from('session').insert(values);
      var data = {"session_id": sid, "char_name": account["char_name"], "subscriber": account["subscriber"]};
      return ApiResponseSuccess(data: data);
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  Future<Response> revive(Request request) async {
    try {
      var requestData = jsonDecode(await request.readAsString());
      var sessionId = requestData['session_id'];
      var responseA = await DatabaseClient().from('session').select().eq('id', sessionId).single();
      var responseB = await DatabaseClient().from('account').select().eq('id', responseA['account_id']).single();
      var data = {"session_id": sessionId, "char_name": responseB["char_name"], "subscriber": responseB["subscriber"]};
      return ApiResponseSuccess(data: data);
    } catch (e) {
      return ApiResponseError(e);
    }
  }
}
