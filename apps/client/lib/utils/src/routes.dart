import 'package:flutter/material.dart';
import 'package:forgottenland/views/pages/character.page.dart';
import 'package:forgottenland/views/pages/guild.page.dart';
import 'package:forgottenland/views/pages/highscores/highscores.page.dart';
import 'package:forgottenland/views/pages/home/home.page.dart';
import 'package:forgottenland/views/pages/login/login.page.dart';
import 'package:forgottenland/views/pages/online/online_characters_page.dart';
import 'package:get/get.dart';
import 'package:utils/utils.dart';

class Routes {
  static final GetPage<dynamic> login = GetPage<dynamic>(name: '/login', page: () => LoginPage());
  static final GetPage<dynamic> home = GetPage<dynamic>(name: '/home', page: () => HomePage());
  static final GetPage<dynamic> highscores = GetPage<dynamic>(name: '/highscores', page: () => const HighscoresPage());
  static final GetPage<dynamic> online = GetPage<dynamic>(name: '/online', page: () => OnlineCharactersPage());
  static final GetPage<dynamic> character = GetPage<dynamic>(name: '/character', page: () => CharacterPage());
  static final GetPage<dynamic> guild = GetPage<dynamic>(name: '/guild', page: () => GuildPage());

  static List<GetPage<dynamic>> getPages() {
    final List<GetPage<dynamic>> list = <GetPage<dynamic>>[
      login,
      home,
      highscores,
      online,
      character,
      guild,
    ];

    for (final String c in LIST.category) {
      String name = '/highscores/${c.toLowerCase().replaceAll(' ', '')}';
      Widget Function() page = () => HighscoresPage(category: c);

      if (c == 'Experience gained' || c == 'Online time') {
        for (final String p in LIST.period) {
          name = '/highscores/$c/$p'.toLowerCase().replaceAll(' ', '');
          page = () => HighscoresPage(category: c, period: p);
          final GetPage<dynamic> route = GetPage<dynamic>(name: name, page: page);
          list.add(route);
        }
      } else {
        final GetPage<dynamic> route = GetPage<dynamic>(name: name, page: page);
        list.add(route);
      }
    }

    return list;
  }
}
