import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/wiki_provider.dart';
import 'package:wikinias/wikibooks_banner.dart';
import 'package:wikinias/wikipedia_banner.dart';
import 'package:wikinias/wiktionary_banner.dart';
import 'package:wikinias/app_settings.dart';
import 'package:wikinias/app_shortcuts.dart';

class AppNavigationControls extends StatelessWidget {
  const AppNavigationControls({super.key, required this.webViewController});

  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    String wikiProject =
        Provider.of<WikiProvider>(context, listen: false).project;
    String wikiHome = '';
    String wikiColor = '';
    String wikiNavigationIcon = '';
    String wikiName = '';

    if (wikiProject == 'Wikibooks') {
      wikiHome = 'https://incubator.wikimedia.org/wiki/Wb/nia/Olayama';
      wikiName = 'Wikibuku Nias';
      wikiColor = '0xff9b00a1';
      wikiNavigationIcon = '0xFFFFFFFF';
    
    } else if (wikiProject == 'Wiktionary') {
      wikiHome = 'https://nia.wiktionary.org';
      wikiName = 'Wikikamus Nias';
      wikiColor = '0xffe9d6ae';
      wikiNavigationIcon = '0xFFF44336';
    } else {
      wikiHome = 'https://nia.wikipedia.org';
      wikiName = 'Wikipedia Nias';
      wikiColor = '0xff121298';
      wikiNavigationIcon = '0xFFFFFFFF';

    }

    var media = MediaQuery.sizeOf(context);

    return Container(
      color: Color(int.parse(wikiColor)),
      child: Row(
        children: [
          media.width > 481
              ? TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    showWikiDialog(context);
                    webViewController.loadRequest(Uri.parse(wikiHome));
                    },
                  child: Text(wikiName,
                    style: GoogleFonts.cinzelDecorative(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Color(int.parse(wikiNavigationIcon)),
                      ),
                    ),
                  ),
                )
              : TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    showWikiDialog(context);
                    webViewController.loadRequest(Uri.parse(wikiHome));
                    },
                  child: Text(
                    'W',
                    style: GoogleFonts.cinzelDecorative(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Color(int.parse(wikiNavigationIcon)),
                      ),
                    ),
                  ),
                ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: Color(int.parse(wikiNavigationIcon)),
            ),
            onPressed: () => webViewController.loadRequest(Uri.parse(wikiHome)),
          ),
          IconButton(
            icon: Icon(Icons.replay, color: Color(int.parse(wikiNavigationIcon))),
            onPressed: () => webViewController.reload(),
          ),
          IconButton(
            icon: Icon(Icons.shuffle_outlined, color: Color(int.parse(wikiNavigationIcon))),
            onPressed: () => wikiProject == 'Wikibooks'
                ? webViewController.loadRequest(Uri.parse(
                    'https://incubator.wikimedia.org/wiki/Special:RandomByTest'))
                : webViewController
                    .loadRequest(Uri.parse('$wikiHome/wiki/Special:Random')),
          ),
          IconButton(
            icon: Icon(Icons.switch_access_shortcut_outlined,
                color: Color(int.parse(wikiNavigationIcon))),
            onPressed: () => showShortcutsDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.more_vert_outlined, color: Color(int.parse(wikiNavigationIcon))),
            onPressed: () => showSettingsDialog(context),
          ),
        ],
      ),
    );
  }

  showWikiDialog(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
            String wikiProject =
        Provider.of<WikiProvider>(context, listen: false).project;
            if (wikiProject == 'Wikibooks') return WikibooksBanner(context: context);
            if (wikiProject == 'Wiktionary') return WiktionaryBanner(context: context);
            return WikipediaBanner(context: context);
      },
    );
  }

  showSettingsDialog(context) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return AppSettings(context: context, webViewController: webViewController,);
      },
    );
  }

  showShortcutsDialog(context) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return AppShortcuts(
          context: context,
          webViewController: webViewController,
        );
      },
    );
  }
}
