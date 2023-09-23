import 'dart:convert';

import 'package:database_client/database_client.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

class UserController {
  UserController(this.databaseClient);

  final IDatabaseClient databaseClient;

  Future<Response> login(Request request) async {
    try {
      var requestData = jsonDecode(await request.readAsString());
      var email = requestData['email'];
      var password = requestData['password'];
      var device = requestData['device'];
      var codec = utf8.fuse(base64);
      String sid = codec.encode({'email': email, 'device': device, 'datetime': MyDateTime.timeStamp()}.toString());
      String token = utf8.fuse(base64).encode('Basic $email:$password');
      List<dynamic> response = await databaseClient.from('account').select().eq('secret', token);

      if (response.isEmpty) return ApiResponse.error('Invalid credentials');

      var account = response.first;
      var values = {'id': sid, 'account_id': account['id']};
      await databaseClient.from('session').insert(values);
      var data = {"session_id": sid, "char_name": account["char_name"], "subscriber": account["subscriber"]};
      return ApiResponse.success(data: data);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }

  Future<Response> revive(Request request) async {
    try {
      var requestData = jsonDecode(await request.readAsString());
      var sessionId = requestData['session_id'];
      var responseA = await databaseClient.from('session').select().eq('id', sessionId).single();
      var responseB = await databaseClient.from('account').select().eq('id', responseA['account_id']).single();
      var data = {"session_id": sessionId, "char_name": responseB["char_name"], "subscriber": responseB["subscriber"]};
      return ApiResponse.success(data: data);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
