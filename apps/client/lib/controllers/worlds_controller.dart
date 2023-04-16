import 'package:dio/dio.dart';
import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/http.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:models/models.dart';

class WorldsController extends Controller {
  final List<World> _list = <World>[];

  ///
  List<World> get list => _list;

  /// [load worlds]
  Future<Response<dynamic>?> load() async {
    if (isLoading.isTrue) return null;
    isLoading.value = true;
    _list.clear();
    _list.add(World(name: 'All'));

    List<dynamic>? aux;

    final Response<dynamic>? response = await Http().get('/worlds');

    final Map<String, dynamic>? data = response?.data as Map<String, dynamic>?;

    aux = data?['worlds']['regular_worlds'] as List<dynamic>?;

    if (aux != null) {
      for (int i = 0; i < aux.length; i++) {
        _list.add(World.fromJson(aux[i] as Map<String, dynamic>));
      }
    }

    isLoading.value = false;
    return response;
  }
}
