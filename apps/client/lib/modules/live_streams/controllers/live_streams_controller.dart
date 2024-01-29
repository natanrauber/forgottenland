import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/paths.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';

class LiveStreamsController extends Controller {
  LiveStreamsController(this.httpClient);

  final IHttpClient httpClient;

  List<LiveStream> streams = <LiveStream>[];
  MyHttpResponse response = MyHttpResponse();

  Future<MyHttpResponse?> getStreams() async {
    if (isLoading.value) return null;
    isLoading.value = true;
    streams.clear();

    response = await httpClient.get('${PATH.forgottenLandApi}/livestreams');

    if (response.success && response.dataAsMap['data'] is List) {
      for (final dynamic e in response.dataAsMap['data'] as List<dynamic>) {
        if (e is Map<String, dynamic>) streams.add(LiveStream.fromJson(e));
      }
    }

    isLoading.value = false;
    return response;
  }
}
