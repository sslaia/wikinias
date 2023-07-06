import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/wiki_provider.dart';

class AppShortcuts extends StatelessWidget {
  const AppShortcuts({
    super.key,
    required this.controller,
  });

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    String niasKeyboard =
        'https://nia.wikipedia.org/wiki/Wikipedia:Fafa_wanura_Nias';
    String aboutApp =
        'https://wikinias.blogspot.com/2022/07/tentang-aplikasi-wikinias.html';
    String aboutWikibooks =
        'https://incubator.wikimedia.org/wiki/Wb/nia/Wikibooks:Sanandrösa';
    String aboutWikipedia =
        'https://nia.wikipedia.org/wiki/Wikipedia:Sanandrösa';
    String aboutWiktionary =
        'https://nia.wiktionary.org/wiki/Wiktionary:Sanandrösa';

    return Container(
      width: double.infinity,
      height: 350.0,
      decoration: const BoxDecoration(
        color: Color(0xfffaf6ed),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'shortcuts',
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black54),
          ).tr(),
          const SizedBox(height: 20.0),
          Consumer<WikiProvider>(
            builder: (context, wiki, child) => Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              children: [
                TextButton(
                  onPressed: () {
                    if (wiki.project == 'Wikibooks') {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/Special:RecentChanges?hidebots=1&translations=filter&hidecategorization=1&hideWikibase=1&limit=250&days=30&urlversion=2&rc-testwiki-project=b&rc-testwiki-code=nia'));
                    } else {
                      controller.loadRequest(
                          Uri.parse('${wiki.url}/wiki/Special:RecentChanges'));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'recent_changes',
                    style: TextStyle(
                      color: Color(0xff121298),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    controller.loadRequest(
                        Uri.parse('${wiki.url}/wiki/Special:SpecialPages'));
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'special_pages',
                    style: TextStyle(
                      color: Color(0xff9b00a1),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    if (wiki.project == 'Wikibooks') {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/Wb/nia/Wikibooks:Angombakhata'));
                    } else {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/${wiki.project}:Angombakhata'));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'announcement',
                    style: TextStyle(
                      color: Color(0xff121298),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    if (wiki.project == 'Wikibooks') {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/Wb/nia/Wikibooks:Bawagöli_zato'));
                    } else {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/${wiki.project}:Bawagöli_zato'));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'community_portal',
                    style: TextStyle(
                      color: Color(0xff9b00a1),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    if (wiki.project == 'Wikibooks') {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/Wb/nia/Wikibooks:Monganga_afo'));
                    } else {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/${wiki.project}:Monganga_afo'));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'village_pump',
                    style: TextStyle(
                      color: Color(0xff121298),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    if (wiki.project == 'Wikibooks') {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/Wb/nia/Wikibooks:Nahia_wamakori'));
                    } else {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/${wiki.project}:Nahia_wamakori'));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'sandbox',
                    style: TextStyle(
                      color: Color(0xff9b00a1),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    if (wiki.project == 'Wikibooks') {
                      controller.loadRequest(
                          Uri.parse('${wiki.url}/wiki/Wb/nia/Help:Fanolo'));
                    } else {
                      controller.loadRequest(
                          Uri.parse('${wiki.url}/wiki/Help:Fanolo'));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'help',
                    style: TextStyle(
                      color: Color(0xff121298),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    if (wiki.project == 'Wikibooks') {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/Wb/nia/Wikibooks:Sangai_halöŵö'));
                    } else {
                      controller.loadRequest(Uri.parse(
                          '${wiki.url}/wiki/${wiki.project}:Sangai_halöŵö'));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'helpers',
                    style: TextStyle(
                      color: Color(0xff9b00a1),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    controller.loadRequest(Uri.parse(niasKeyboard));
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'nias_keyboard',
                    style: TextStyle(
                      color: Color(0xff121298),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    if (wiki.project == 'Wikibooks') {
                      controller.loadRequest(Uri.parse(aboutWikibooks));
                    } else if (wiki.project == 'Wiktionary') {
                      controller.loadRequest(Uri.parse(aboutWiktionary));
                    } else {
                      controller.loadRequest(Uri.parse(aboutWikipedia));
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'about_wiki',
                    style: TextStyle(
                      color: Color(0xff9b00a1),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () {
                    controller.loadRequest(Uri.parse(aboutApp));
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'about_app',
                    style: TextStyle(
                      color: Color(0xff121298),
                    ),
                  ).tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
