import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/wiki_provider.dart';

class AppShortcuts extends StatelessWidget {
  const AppShortcuts(
      {super.key, required this.context, required this.webViewController});

  final BuildContext context;
  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    String niasKeyboard =
        'https://nia.wikipedia.org/wiki/Wikipedia:Fafa_wanura_Nias';
    String aboutApp =
        'https://wikinias.blogspot.com/2022/07/tentang-aplikasi-wikinias.html';
    String aboutWiki = '';
    String recentChanges = '';

    String wikiProject =
        Provider.of<WikiProvider>(context, listen: false).project;
    String wikiHome = '';
    String wikiNameSpace = '';
    String wikiHelp = '';

    if (wikiProject == 'Wikibooks') {
      aboutWiki = 'https://incubator.wikimedia.org/wiki/Wb/nia/Wikibooks:Sanandrösa';
      wikiHome = 'https://incubator.wikimedia.org';
      recentChanges =
          '/wiki/Special:RecentChanges?hidebots=1&translations=filter&hidecategorization=1&hideWikibase=1&limit=250&days=30&urlversion=2&rc-testwiki-project=b&rc-testwiki-code=nia';
      wikiNameSpace = 'Wb/nia/Wikibooks';
      wikiHelp = 'Wb/nia/Help';
    } else if (wikiProject == 'Wiktionary') {
      aboutWiki = 'https://nia.wiktionary.org/wiki/Wiktionary:Sanandrösa';
      wikiHome = 'https://nia.wiktionary.org';
      recentChanges = '/wiki/Special:RecentChanges';
      wikiNameSpace = 'Wiktionary';
      wikiHelp = 'Help';
    } else {
      aboutWiki = 'https://nia.wikipedia.org/wiki/Wikipedia:Sanandrösa';
      wikiHome = 'https://nia.wikipedia.org';
      recentChanges = '/wiki/Special:RecentChanges';
      wikiNameSpace = 'Wikipedia';
      wikiHelp = 'Help';
    }

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
                color: Colors.black),
          ).tr(),
          const SizedBox(height: 20.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            children: [
              TextButton(
                onPressed: () {
                  webViewController
                      .loadRequest(Uri.parse('$wikiHome$recentChanges'));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff121298)))),
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
                  webViewController.loadRequest(
                      Uri.parse('$wikiHome/wiki/Special:SpecialPages'));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff9b00a1)))),
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
                  webViewController.loadRequest(
                      Uri.parse('$wikiHome/wiki/$wikiNameSpace:Angombakhata'));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff121298)))),
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
                  webViewController.loadRequest(
                      Uri.parse('$wikiHome/wiki/$wikiNameSpace:Bawagöli_zato'));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff9b00a1)))),
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
                  webViewController.loadRequest(
                      Uri.parse('$wikiHome/wiki/$wikiNameSpace:Monganga_afo'));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff121298)))),
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
                  webViewController.loadRequest(Uri.parse(
                      '$wikiHome/wiki/$wikiNameSpace:Nahia_wamakori'));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff9b00a1)))),
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
                  webViewController.loadRequest(
                      Uri.parse('$wikiHome/wiki/$wikiHelp:Fanolo'));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff121298)))),
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
                  webViewController.loadRequest(
                      Uri.parse('$wikiHome/wiki/$wikiNameSpace:Sangai_halöŵö'));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff9b00a1)))),
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
                  webViewController.loadRequest(Uri.parse(niasKeyboard));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff121298)))),
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
                  webViewController.loadRequest(Uri.parse(aboutWiki));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff9b00a1)))),
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
                  webViewController.loadRequest(Uri.parse(aboutApp));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff121298)))),
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
        ],
      ),
    );
  }
}
