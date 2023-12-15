import 'dart:convert';

import 'package:database_client/database_client.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

class UserController {
  UserController(this.databaseClient);

  final IDatabaseClient databaseClient;

  Future<Response> login(Request request) async {
    try {
      dynamic requestData = jsonDecode(await request.readAsString());
      dynamic email = requestData['email'];
      dynamic password = requestData['password'];
      dynamic device = requestData['device'];
      Codec<String, String> codec = utf8.fuse(base64);
      String sid = codec.encode(
        <String, dynamic>{
          'email': email,
          'device': device,
          'datetime': DT.tibia.timeStamp(),
        }.toString(),
      );
      String token = utf8.fuse(base64).encode('Basic $email:$password');
      List<dynamic> response = await databaseClient.from('account').select().eq('secret', token);

      if (response.isEmpty) return ApiResponse.error('Invalid credentials');

      dynamic account = response.first;
      Map<String, dynamic> values = <String, dynamic>{'id': sid, 'account_id': account['id']};
      await databaseClient.from('session').insert(values);
      Map<String, dynamic> data = <String, dynamic>{
        'session_id': sid,
        'char_name': account['char_name'],
        'subscriber': account['subscriber'],
      };
      return ApiResponse.success(data: data);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }

  Future<Response> revive(Request request) async {
    try {
      dynamic requestData = jsonDecode(await request.readAsString());
      dynamic sessionId = requestData['session_id'];
      dynamic responseA = await databaseClient.from('session').select().eq('id', sessionId).single();
      dynamic responseB = await databaseClient.from('account').select().eq('id', responseA['account_id']).single();
      Map<String, dynamic> data = <String, dynamic>{
        'session_id': sessionId,
        'char_name': responseB['char_name'],
        'subscriber': responseB['subscriber']
      };
      return ApiResponse.success(data: data);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
