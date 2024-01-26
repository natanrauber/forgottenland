import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class WorldsController extends Controller {
  WorldsController(this.httpClient);

  final IHttpClient httpClient;

  final List<World> list = <World>[];

  /// [load worlds]
  Future<MyHttpResponse?> getWorlds() async {
    if (isLoading.value) return null;
    if (list.isNotEmpty) return null;

    list.clear();
    list.add(World(name: 'All'));

    List<dynamic>? aux;
    MyHttpResponse? response;

    try {
      response = await httpClient.get('${PATH.tibiaDataApi}/worlds');
      aux = response.dataAsMap['worlds']['regular_worlds'] as List<dynamic>?;
    } catch (e) {
      customPrint(e.toString(), color: PrintColor.red);
    }

    if (aux != null) {
      for (int i = 0; i < aux.length; i++) {
        list.add(World.fromJson(aux[i] as Map<String, dynamic>));
      }
    }

    isLoading.value = false;
    return response;
  }
}
