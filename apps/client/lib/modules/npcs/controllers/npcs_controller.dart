import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:forgottenland/views/widgets/src/fields/custom_text_field.widget.dart';
import 'package:get/get.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';

class NpcsController extends Controller {
  NpcsController(this.httpClient);

  final IHttpClient httpClient;

  final List<NPC> _rawList = <NPC>[];
  RxList<NPC> npcs = <NPC>[].obs;
  MyHttpResponse response = MyHttpResponse();
  RxBool isLoadingNpc = false.obs;

  TextController searchController = TextController();

  Future<MyHttpResponse?> getAll() async {
    if (isLoading.value) return null;
    if (_rawList.isNotEmpty) return null;

    isLoading.value = true;
    response = await httpClient.get('${PATH.forgottenLandApi}/npcs');

    if (response.success && response.dataAsMap['data'] is List) {
      for (final dynamic e in response.dataAsMap['data'] as List<dynamic>) {
        if (e is Map<String, dynamic>) _rawList.add(NPC.fromJson(e));
      }
    }

    filterList();
    isLoading.value = false;
    return response;
  }

  Future<MyHttpResponse?> getTranscripts(NPC npc) async {
    if (isLoadingNpc.value) return null;

    isLoadingNpc.value = true;
    response = await httpClient.get('${PATH.forgottenLandApi}/npcs/${npc.name?.replaceAll(' ', '_')}');

    if (response.success) npc.updateFromJson(response.dataAsMap);

    isLoadingNpc.value = false;
    return response;
  }

  void filterList() {
    npcs.clear();
    for (final NPC e in _rawList) {
      if (_matchFilter(e, searchController.text)) npcs.add(e);
    }
  }

  bool _matchFilter(NPC npc, String text) {
    if (npc.name?.toLowerCase().contains(text.toLowerCase()) ?? false) return true;
    return false;
  }
}
