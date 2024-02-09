import 'package:database_client/database_client.dart';
import 'package:models/models.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

abstract class IOnlineController {
  Future<Response> getOnlineNow(Request request);
  Future<Response> getOnlineTime(Request request, String date);
}

class OnlineController implements IOnlineController {
  OnlineController(this.databaseClient);

  final IDatabaseClient databaseClient;

  @override
  Future<Response> getOnlineNow(Request request) async {
    try {
      dynamic response = await databaseClient.from('online').select().maybeSingle();
      if (response == null) return ApiResponse.noContent();
      Online online = Online.fromJson((response['data'] as Map<String, dynamic>));
      return ApiResponse.success(data: online.toJson());
    } catch (e) {
      return ApiResponse.error(e);
    }
  }

  @override
  Future<Response> getOnlineTime(Request request, String date) async {
    try {
      dynamic response = await databaseClient.from('onlinetime').select().eq('date', date).maybeSingle();
      if (response == null) return ApiResponse.noContent();
      Online online = Online.fromJson((response['data'] as Map<String, dynamic>?) ?? <String, dynamic>{});
      return ApiResponse.success(data: online.toJson());
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
