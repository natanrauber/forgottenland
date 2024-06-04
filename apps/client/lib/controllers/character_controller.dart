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
  MyHttpResponse response = MyHttpResponse();

  Future<void> searchCharacter() async {
    isLoading.value = true;
    character.value = Character();

    try {
      final String name = searchCtrl.text.toLowerCase();
      response = await httpClient.get('${PATH.forgottenLandApi}/character/${name.replaceAll(' ', '%20')}');
      if (response.success) character.value = Character.fromJson(response.dataAsMap['data'] as Map<String, dynamic>);
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
  }
}
