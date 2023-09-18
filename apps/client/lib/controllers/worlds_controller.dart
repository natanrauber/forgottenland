import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:forgottenland/utils/utils.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';

class WorldsController extends Controller {
  WorldsController(this.httpClient);

  final IHttpClient httpClient;

  final List<World> _list = <World>[];

  ///
  List<World> get list => _list;

  /// [load worlds]
  Future<MyHttpResponse?> load() async {
    if (isLoading.isTrue) return null;
    isLoading.value = true;
    _list.clear();
    _list.add(World(name: 'All'));

    List<dynamic>? aux;
    MyHttpResponse? response;

    try {
      response = await httpClient.get('${PATH.tibiaDataApi}/worlds');
      aux = response.dataAsMap['worlds']['regular_worlds'] as List<dynamic>?;
    } catch (e) {
      customPrint(e.toString());
    }

    if (aux != null) {
      for (int i = 0; i < aux.length; i++) {
        _list.add(World.fromJson(aux[i] as Map<String, dynamic>));
      }
    }

    isLoading.value = false;
    return response;
  }
}
