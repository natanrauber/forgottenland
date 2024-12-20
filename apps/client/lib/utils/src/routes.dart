import 'package:flutter/material.dart';
import 'package:forgottenland/modules/bazaar/views/bazaar_page.dart';
import 'package:forgottenland/modules/books/views/books_page.dart';
import 'package:forgottenland/modules/live_streams/views/live_streams_page.dart';
import 'package:forgottenland/modules/npcs/views/npcs_page.dart';
import 'package:forgottenland/modules/splash/splash_page.dart';
import 'package:forgottenland/views/pages/character_page.dart';
import 'package:forgottenland/views/pages/guild.page.dart';
import 'package:forgottenland/views/pages/highscores/highscores.page.dart';
import 'package:forgottenland/views/pages/home/home.page.dart';
import 'package:forgottenland/views/pages/login/login.page.dart';
import 'package:forgottenland/views/pages/online/online_characters_page.dart';
import 'package:get/get.dart';
import 'package:utils/utils.dart';

class MyPage extends GetPage<dynamic> {
  MyPage(
    String name,
    Widget page,
  ) : super(
          name: name,
          page: () => page,
          transition: Transition.noTransition,
          transitionDuration: Duration.zero,
        );
}

class Routes {
  static final MyPage bazaar = MyPage('/bazaar', BazaarPage());
  static final MyPage books = MyPage('/books', BooksPage());
  static final MyPage character = MyPage('/character', CharacterPage());
  static final MyPage guild = MyPage('/guild', GuildPage());
  static final MyPage highscores = MyPage('/highscores', const HighscoresPage());
  static final MyPage home = MyPage('/home', HomePage());
  static final MyPage livestreams = MyPage('/livestreams', LiveStreamsPage());
  static final MyPage login = MyPage('/login', LoginPage());
  static final MyPage npcs = MyPage('/npcs', NpcsPage());
  static final MyPage online = MyPage('/online', OnlineCharactersPage());
  static final MyPage splash = MyPage('/splash', SplashPage());

  static List<MyPage> getPages() {
    final List<MyPage> list = <MyPage>[
      bazaar,
      books,
      character,
      guild,
      highscores,
      home,
      livestreams,
      login,
      npcs,
      online,
      splash,
    ];

    for (final String c in LIST.category) {
      String name = '/highscores/${c.toLowerCase().replaceAll(' ', '')}';
      Widget page = HighscoresPage(category: c);

      if (c == 'Experience gained' || c == 'Online time') {
        for (final String p in LIST.timeframe) {
          name = '/highscores/$c/$p'.toLowerCase().replaceAll(' ', '');
          page = HighscoresPage(category: c, timeframe: p);
          final MyPage route = MyPage(name, page);
          list.add(route);
        }
      } else {
        final MyPage route = MyPage(name, page);
        list.add(route);
      }
    }

    return list;
  }
}
