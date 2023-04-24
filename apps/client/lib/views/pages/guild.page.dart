import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';
import 'package:forgottenland/views/widgets/src/other/app_page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:utils/utils.dart';

class GuildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppPage(
        padding: const EdgeInsets.symmetric(vertical: 20),
        body: Column(
          children: <Widget>[
            //
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  //
                  ClipOval(
                    child: Container(
                      height: 200,
                      width: 200,
                      padding: const EdgeInsets.all(10),
                      color: Colors.black,
                      child: Image.asset(
                        'assets/logo.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _text(
                    '     We live and fight for a forgotten land, where the first mysteries intrigued the first warriors. In time, many have left us, entering the depths of oblivion forever. Through this union, we forge eternal alliances, where we insert our name in history.',
                  ),

                  const SizedBox(height: 20),

                  _text(
                    '     The guild was founded on Calmera on Apr 14 2020. It is currently active and always open for applications.',
                  ),

                  const SizedBox(height: 100),

                  _text(
                    'You can find us on instagram:',
                  ),
                ],
              ),
            ),

            Container(
              height: 120,
              alignment: Alignment.center,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: 40),
                itemCount: LIST.member.length,
                itemBuilder: _itemBuilder,
              ),
            ),

            const SizedBox(height: 50),

            _viewOnTibiaWebsiteButton(),

            const SizedBox(height: 50),
          ],
        ),
      );

  Widget _text(String text) => SelectableText(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.justify,
      );

  Widget _itemBuilder(BuildContext context, int index) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (MAP.instagram[LIST.member[index]] != null) {
              launchUrlString(
                MAP.instagram[LIST.member[index]]!,
              );
            }
          },
          child: SizedBox(
            width: 120,
            child: Image.asset('assets/outfit/${LIST.member[index]}.png'),
          ),
        ),
      );

  Widget _viewOnTibiaWebsiteButton() => Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.all(20),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => launchUrlString(
              'https://www.tibia.com/community/?subtopic=guilds&page=view&GuildName=Forgotten+Land',
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgPaper,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    'View on Tibia.com',
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.arrow_up_right_square,
                    size: 18,
                    color: AppColors.primary,
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
