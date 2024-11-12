import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required WebViewController controller,
  }) : _controller = controller;

  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => PopupMenuButton<String>(
        onSelected: (String result) {
          // Navigate based on the selected menu item
          switch (result) {
            case 'wikipedia':
              wiki.setProject('Wikipedia', 'https://nia.m.wikipedia.org', Color(0xff121298));
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wikipedia');
              break;
            case 'wiktionary':
              wiki.setProject('Wiktionary', 'https://nia.m.wiktionary.org', Color(0xffe9d6ae));
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wiktionary');
              break;
            case 'wikibooks':
              wiki.setProject('Wb/nia/Wikibooks', 'https://incubator.m.wikimedia.org', Color(0xff9b00a1));
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wikibooks');
              break;
            case 'nias':
              context.setLocale(Locale('id'));
              break;
            case 'english':
              context.setLocale(Locale('en'));
              break;
            case 'new':
              // Navigator.pop(context);
              _controller.loadRequest(
                Uri.parse('https://wikinias.blogspot.com/2024/11/perubahan-terbaru.html'));
              break;
            case 'community':
              // Navigator.pop(context);
              _controller.loadRequest(
                Uri.parse('https://nia.wiktionary.org/wiki/Wiktionary:Sanandrösa'));
              break;
            case 'application':
              // Navigator.pop(context);
              _controller.loadRequest(
                Uri.parse('https://wikinias.blogspot.com/2022/07/tentang-aplikasi-wikinias.html'));
              break;
          }
        },
        tooltip: 'settings'.tr(),
        icon: Icon(Icons.more_vert_outlined,
            color: (wiki.name == 'Wiktionary') ? Colors.black : Colors.white70),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'wikipedia',
            child: Text(
              'wikipedia',
              style: TextStyle(
                  color: (wiki.name == 'Wiktionary')
                      ? Colors.black87
                      : wiki.color),
            ).tr(),
          ),
          PopupMenuItem<String>(
            value: 'wiktionary',
            child: Text(
              'wiktionary',
              style: TextStyle(
                  color: (wiki.name == 'Wiktionary')
                      ? Colors.black87
                      : wiki.color),
            ).tr(),
          ),
          PopupMenuItem<String>(
            value: 'wikibooks',
            child: Text(
              'wikibooks',
              style: TextStyle(
                  color: (wiki.name == 'Wiktionary')
                      ? Colors.black87
                      : wiki.color),
            ).tr(),
          ),
          PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'nias',
            child: Text(
              'nias',
              style: TextStyle(
                  color: (wiki.name == 'Wiktionary')
                      ? Colors.black87
                      : wiki.color),
            ).tr(),
          ),
          PopupMenuItem<String>(
            value: 'english',
            child: Text(
              'english',
              style: TextStyle(
                  color: (wiki.name == 'Wiktionary')
                      ? Colors.black87
                      : wiki.color),
            ).tr(),
          ),
          PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'new',
            child: Text(
              'new',
              style: TextStyle(
                  color: (wiki.name == 'Wiktionary')
                      ? Colors.black87
                      : wiki.color),
            ).tr(),
          ),
          PopupMenuItem<String>(
            value: 'community',
            child: Text(
              'community',
              style: TextStyle(
                  color: (wiki.name == 'Wiktionary')
                      ? Colors.black87
                      : wiki.color),
            ).tr(),
          ),
          PopupMenuItem<String>(
            value: 'application',
            child: Text(
              'application',
              style: TextStyle(
                  color: (wiki.name == 'Wiktionary')
                      ? Colors.black87
                      : wiki.color),
            ).tr(),
          ),
        ],
      ),
    );
  }
}
