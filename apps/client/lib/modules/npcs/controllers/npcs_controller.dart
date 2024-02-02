import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:get/get.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';

class NpcsController extends Controller {
  NpcsController(this.httpClient);

  final IHttpClient httpClient;

  RxList<NPC> npcs = <NPC>[].obs;
  MyHttpResponse response = MyHttpResponse();
  RxBool isLoadingNpc = false.obs;

  Future<MyHttpResponse?> getAll() async {
    if (isLoading.value) return null;
    if (npcs.isNotEmpty) return null;

    isLoading.value = true;
    response = await httpClient.get('${PATH.forgottenLandApi}/npcs');

    if (response.success && response.dataAsMap['data'] is List) {
      for (final dynamic e in response.dataAsMap['data'] as List<dynamic>) {
        if (e is Map<String, dynamic>) npcs.add(NPC.fromJson(e));
      }
    }

    isLoading.value = false;
    return response;
  }

  Future<MyHttpResponse?> getTranscripts(NPC npc) async {
    if (isLoadingNpc.value) return null;

    isLoadingNpc.value = true;
    response = await httpClient.get('${PATH.forgottenLandApi}/npc/transcripts/${npc.name?.replaceAll(' ', '_')}');

    if (response.success) npc.updateFromJson(response.dataAsMap);

    isLoadingNpc.value = false;
    return response;
  }
}
