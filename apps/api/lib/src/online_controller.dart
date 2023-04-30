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
  OnlineController(this.databaseClient);

  final IDatabaseClient databaseClient;

  @override
  Future<Response> getOnlineNow(Request request) async {
    try {
      dynamic response = await databaseClient.from('online').select().single();
      Online online = Online.fromJson((response['data'] as Map<String, dynamic>));
      return ApiResponseSuccess(data: online.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }

  @override
  Future<Response> getOnlineTime(Request request) async {
    try {
      String? date = request.params['date'];
      dynamic response = await databaseClient.from('onlinetime').select().eq('date', date).single();
      Online online = Online.fromJson((response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{});
      return ApiResponseSuccess(data: online.toJson());
    } catch (e) {
      return ApiResponseError(e);
    }
  }
}
