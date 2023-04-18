import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/rxmodels/character_rxmodel.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class CharacterController extends Controller {
  RxCharacter data = Character().obs;

  Future<MyHttpResponse> get(String name) async {
    isLoading.value = true;
    data.value = Character();

    final MyHttpResponse response = await MyHttpClient().get('${PATH.tibiaDataApi}/character/$name');

    if (response.success) {
      if (response.dataAsMap['characters'] is Map<String, dynamic>) {
        data.value = Character.fromJson(response.dataAsMap['characters'] as Map<String, dynamic>);
      }
    }

    isLoading.value = true;
    update();
    return response;
  }
}
