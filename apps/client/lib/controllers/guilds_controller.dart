import 'package:dio/dio.dart';
import 'package:forgottenland/controllers/controller.dart';
import 'package:forgottenland/utils/src/http.dart';
import 'package:models/models.dart';

class GuildsController extends Controller {
  final List<Guild> list = <Guild>[];

  /// [load guild list]
  Future<bool> load(List<World> worlds) async {
    list.clear();

    Response<dynamic>? response;

    for (final World world in worlds) {
      response = await Http().get(
        '/guilds/${world.name}',
      );

      final WorldGuilds worldGuildList = WorldGuilds.fromJson(
        response?.data as Map<String, dynamic>,
      );

      for (final Active activeGuild in worldGuildList.guilds?.active ?? <Active>[]) {
        response = await Http().get(
          '/guild/${activeGuild.name}.json',
        );

        final Guild guild = Guild.fromJson(
          response?.data as Map<String, dynamic>,
        );

        if (guild.rookerGuild == true) {
          list.add(guild);
          update();
        }
      }
    }

    return true;
  }
}
