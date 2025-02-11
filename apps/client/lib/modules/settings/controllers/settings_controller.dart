import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/modules/settings/models/feature_model.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:http_client/http_client.dart';

class SettingsController extends Controller {
  SettingsController(this.httpClient);

  final IHttpClient httpClient;

  List<Feature> features = <Feature>[];

  Future<MyHttpResponse?> getFeatures() async {
    if (isLoading.value) return null;
    if (features.isNotEmpty) return null;

    isLoading.value = true;

    final MyHttpResponse response = await httpClient.get('${PATH.forgottenLandApi}/settings/features');

    if (response.success && response.dataAsMap['data'] is List) {
      for (final dynamic e in response.dataAsMap['data'] as List<dynamic>) {
        if (e is Map<String, dynamic>) features.add(Feature.fromJson(e));
      }
    }

    isLoading.value = false;
    return response;
  }
}
