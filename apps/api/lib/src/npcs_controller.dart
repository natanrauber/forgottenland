import 'package:http_client/http_client.dart';
import 'package:shelf/shelf.dart';
import 'package:utils/utils.dart';

abstract class INPCsController {
  Future<Response> getAll(Request request);
  Future<Response> getTranscripts(Request request, String name);
}

class NPCsController implements INPCsController {
  NPCsController(this.httpClient);

  final IHttpClient httpClient;

  @override
  Future<Response> getAll(Request request) async {
    try {
      MyHttpResponse response = await httpClient.get(
        'https://api.github.com/repos/s2ward/tibia/git/trees/main?recursive=1',
      );

      List<dynamic> filteredList = <dynamic>[];
      if (response.dataAsMap['tree'] is List<dynamic>) {
        for (dynamic e in response.dataAsMap['tree']) {
          if (e is Map<String, dynamic>) {
            if (e['path'] is String) {
              if ((e['path'] as String).contains('npc/Rookgaard/')) {
                filteredList.add(e);
              }
            }
          }
        }
      }

      return ApiResponse.success(data: filteredList);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }

  @override
  Future<Response> getTranscripts(Request request, String name) async {
    try {
      MyHttpResponse response = await httpClient.get(
        'https://raw.githubusercontent.com/s2ward/tibia/main/npc/Rookgaard/$name.txt',
      );

      return ApiResponse.success(data: response.data);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
