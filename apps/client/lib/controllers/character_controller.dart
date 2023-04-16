import 'package:dio/dio.dart';
import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/rxmodels/character_rxmodel.dart';
import 'package:forgottenland/utils/src/http.dart';
import 'package:models/models.dart';

class CharacterController extends Controller {
  RxCharacter data = Character().obs;

  Future<Response<dynamic>?> get(String name) async {
    isLoading.value = true;
    data.value = Character();

    final Response<dynamic>? response = await Http().get(
      '/character/$name',
    );

    if (response?.data is Map<String, dynamic>) {
      if (response?.data['characters'] is Map<String, dynamic>) {
        data.value = Character.fromJson(response?.data['characters'] as Map<String, dynamic>);
      }
    }

    isLoading.value = true;
    update();
    return response;
  }
}
