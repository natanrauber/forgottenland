import 'package:forgottenland/controllers/controller.dart';
import 'package:http_client/http_client.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class GuildsController extends Controller {
  final List<Guild> list = <Guild>[];

  Future<bool> load(List<World> worlds) async {
    list.clear();

    MyHttpResponse response;

    for (final World world in worlds) {
      response = await MyHttpClient().get('${PATH.tibiaDataApi}/guilds/${world.name}');

      final WorldGuilds worldGuildList = WorldGuilds.fromJson(response.dataAsMap);

      for (final Active activeGuild in worldGuildList.guilds?.active ?? <Active>[]) {
        response = await MyHttpClient().get('${PATH.tibiaDataApi}/guild/${activeGuild.name}.json');

        final Guild guild = Guild.fromJson(response.dataAsMap);

        if (guild.rookerGuild == true) {
          list.add(guild);
          update();
        }
      }
    }

    return true;
  }
}
