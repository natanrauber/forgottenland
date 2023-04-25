import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/api_responses.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class IOnlineController {
  Future<Response> getOnlineNow(Request request);
  Future<Response> getOnlineTime(Request request);
}

class OnlineController implements IOnlineController {
  factory OnlineController() => _singleton;
  OnlineController._internal();
  static final OnlineController _singleton = OnlineController._internal();

  @override
  Future<Response> getOnlineNow(Request request) async {
    try {
      dynamic response = await DatabaseClient().from('online').select().single();
      Online online = Online.fromJson((response['data'] as Map<String, dynamic>));
      return ApiResponseSuccess(data: online.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  @override
  Future<Response> getOnlineTime(Request request) async {
    try {
      String? day = request.params['day'];
      dynamic response = await DatabaseClient().from('online-time').select().eq('day', day).single();
      Online online = Online.fromJson((response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{});
      return ApiResponseSuccess(data: online.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }
}
