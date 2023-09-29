import 'package:database_client/database_client.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

abstract class IBazaarController {
  Future<Response> get(Request request);
}

class BazaarController implements IBazaarController {
  BazaarController(this.databaseClient);

  final IDatabaseClient databaseClient;

  @override
  Future<Response> get(Request request) async {
    try {
      dynamic response = await databaseClient.from('bazaar').select().single();
      return ApiResponse.success(data: response['data'] as Map<String, dynamic>);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
