import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../utils/datetime.dart';
import '../utils/responses.dart';
import 'supabase_client.dart';

class User {
  Future<Response> login(Request request) async {
    dynamic data = jsonDecode(await request.readAsString());
    dynamic email = data['email'];
    dynamic password = data['password'];
    dynamic device = data['device'];
    String sessionId = utf8.fuse(base64).encode(
          {
            'email': email,
            'device': device,
            'datetime': MyDateTime.timeStamp(),
          }.toString(),
        );
    dynamic response;

    try {
      String token = utf8.fuse(base64).encode('Basic $email:$password');

      response = await MySupabaseClient().client.from('account').select().eq('secret', token).single();

      if (response['id'] != null) {
        await MySupabaseClient().client.from('session').insert(
          {
            'id': sessionId,
            'account_id': response['id'],
          },
        );
      }
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess(
      data: {
        "session_id": sessionId,
        "char_name": response["char_name"],
        "subscriber": response["subscriber"],
      },
    );
  }

  Future<Response> revive(Request request) async {
    dynamic data = jsonDecode(await request.readAsString());
    dynamic sessionId = data['session_id'];
    dynamic response;

    try {
      response = await MySupabaseClient().client.from('session').select().eq('id', sessionId).single();

      if (response['account_id'] != null) {
        response = await MySupabaseClient().client.from('account').select().eq('id', response['account_id']).single();
      }
    } catch (e) {
      return ResponseError(e);
    }
    return ResponseSuccess(
      data: {
        "session_id": sessionId,
        "char_name": response["char_name"],
        "subscriber": response["subscriber"],
      },
    );
  }
}
