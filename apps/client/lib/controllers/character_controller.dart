import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/rxmodels/character_rxmodel.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:forgottenland/views/widgets/widgets.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class CharacterController extends Controller {
  CharacterController(this.httpClient);

  final IHttpClient httpClient;

  final TextController searchCtrl = TextController();
  RxCharacter character = Character().obs;
  MyHttpResponse searchResponse = MyHttpResponse();

  Future<MyHttpResponse> searchCharacter() async {
    isLoading.value = true;
    character.value = Character();

    try {
      searchResponse = await httpClient.get('${PATH.forgottenLandApi}/character/${searchCtrl.text}');

      if (searchResponse.success) {
        if (searchResponse.dataAsMap['data'] is Map<String, dynamic>) {
          character.value = Character.fromJson(searchResponse.dataAsMap['data'] as Map<String, dynamic>);
        }
      }
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
    update();
    return searchResponse;
  }
}
