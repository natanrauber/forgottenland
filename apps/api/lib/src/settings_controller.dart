import 'package:database_client/database_client.dart';
import 'package:forgottenlandapi/utils/error_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:utils/utils.dart';

class SettingsController {
  SettingsController(this.databaseClient);

  final IDatabaseClient databaseClient;

  Future<Response> get(Request request) async {
    String? value = request.params['value']?.toLowerCase();

    if (value == null) return ApiResponse.error('Missing param "value"');
    if (value.contains('features')) return _getFeatures();
    return ApiResponse.notFound();
  }

  Future<Response> _getFeatures() async {
    try {
      dynamic response = await databaseClient.from('features').select();
      return ApiResponse.success(data: response);
    } catch (e) {
      return handleError(e);
    }
  }
}
