import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/rxmodels/character_rxmodel.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';

class CharacterController extends Controller {
  CharacterController(this.httpClient);

  final IHttpClient httpClient;

  RxCharacter data = Character().obs;

  Future<MyHttpResponse> get(String name) async {
    isLoading.value = true;
    data.value = Character();

    final MyHttpResponse response = await httpClient.get('${PATH.forgottenLandApi}/character/$name');

    if (response.success) {
      if (response.dataAsMap['data'] is Map<String, dynamic>) {
        data.value = Character.fromJson(response.dataAsMap['data'] as Map<String, dynamic>);
      }
    }

    isLoading.value = false;
    update();
    return response;
  }
}
