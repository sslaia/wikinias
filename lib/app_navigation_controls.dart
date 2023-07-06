import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/wiki_provider.dart';
import 'package:wikinias/app_settings.dart';
import 'package:wikinias/app_shortcuts.dart';

class AppNavigationControls extends StatelessWidget {
  final WebViewController controller;

  const AppNavigationControls({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => Container(
        color: Color(int.parse(wiki.color)),
        child: Row(
          children: [
            media.width > 481
                ? TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (wiki.project == 'Wikibooks') {
                        controller.loadRequest(
                            Uri.parse(wiki.url));
                      } else {
                        controller.loadRequest(Uri.parse(wiki.url));
                      }
                      showWikiDialog(context, wiki.project, wiki.color);
                    },
                    child: Text(
                      '${wiki.project} Nias',
                      style: GoogleFonts.cinzelDecorative(
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: (wiki.project == 'Wiktionary')
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),
                  )
                : TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (wiki.project == 'Wikibooks') {
                        controller.loadRequest(
                            Uri.parse('${wiki.url}/wiki/Wb/nia/Olayama'));
                      } else {
                        controller.loadRequest(Uri.parse(wiki.url));
                      }
                      showWikiDialog(context, wiki.project, wiki.color);
                    },
                    child: Text(
                      'W',
                      style: GoogleFonts.cinzelDecorative(
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: (wiki.project == 'Wiktionary')
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.replay,
                  color: (wiki.project == 'Wiktionary')
                      ? Colors.red
                      : Colors.white),
              onPressed: () => controller.reload(),
            ),
            IconButton(
              icon: Icon(Icons.shuffle_outlined,
                  color: (wiki.project == 'Wiktionary')
                      ? Colors.red
                      : Colors.white),
              onPressed: () => wiki.project == 'Wikibooks'
                  ? controller.loadRequest(Uri.parse(
                      'https://incubator.wikimedia.org/wiki/Special:RandomByTest'))
                  : controller.loadRequest(
                      Uri.parse('${wiki.url}/wiki/Special:Random')),
            ),
            IconButton(
              icon: Icon(Icons.switch_access_shortcut_outlined,
                  color: (wiki.project == 'Wiktionary')
                      ? Colors.red
                      : Colors.white),
              onPressed: () => showShortcutsDialog(context),
            ),
            IconButton(
              icon: Icon(Icons.more_vert_outlined,
                  color: (wiki.project == 'Wiktionary')
                      ? Colors.red
                      : Colors.white),
              onPressed: () => showSettingsDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  showWikiDialog(BuildContext context, String project, String color) {
    String wiki = project.toLowerCase();

    return showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xfffaf6ed),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          width: double.infinity,
          height: 200.0,
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${wiki}_banner',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: (project == 'Wiktionary') ? Colors.black87 : Color(int.parse(color)),
                ),
              ).tr(),
              Text(
                'wikinias_slogan',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: (project == 'Wiktionary') ? Colors.black87 : Color(int.parse(color)),
                ),
              ).tr(),
            ],
          ),
        );
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
        return AppSettings(
          controller: controller,
        );
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
          controller: controller,
        );
      },
    );
  }
}
