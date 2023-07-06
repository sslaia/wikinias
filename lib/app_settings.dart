import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/wiki_provider.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({
    super.key,
    required this.controller,
  });

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => Container(
        decoration: const BoxDecoration(
          color: Color(0xfffaf6ed),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        width: double.infinity,
        height: 350.0,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'choose_language',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54),
            ).tr(),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'English',
                    style: TextStyle(
                      color: Color(0xff9b00a1),
                    ),
                  ),
                ),
                const SizedBox(width: 50.0),
                TextButton(
                  onPressed: () {
                    context.setLocale(const Locale('id'));
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(int.parse(wiki.color))))),
                  ),
                  child: const Text(
                    'Li Niha',
                    style: TextStyle(
                      color: Color(0xff121298),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Text(
              'choose_project',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54),
            ).tr(),
            const SizedBox(height: 16.0),
            Consumer<WikiProvider>(
              builder: (context, wiki, child) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      wiki.setProject('Wikipedia');
                      wiki.setUrl('https://nia.wikipedia.org');
                      wiki.setColor('0xff121298');
                      controller
                          .loadRequest(Uri.parse('https://nia.wikipedia.org'));
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(int.parse(wiki.color))))),
                    ),
                    child: const Text(
                      'wikipedia',
                      style: TextStyle(
                        color: Color(0xff121298),
                      ),
                    ).tr(),
                  ),
                  const SizedBox(width: 32.0),
                  TextButton(
                    onPressed: () {
                      wiki.setProject('Wiktionary');
                      wiki.setUrl('https://nia.wiktionary.org');
                      wiki.setColor('0xffe9d6ae');
                      controller
                          .loadRequest(Uri.parse('https://nia.wiktionary.org'));
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(int.parse(wiki.color))))),
                    ),
                    child: const Text(
                      'wiktionary',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ).tr(),
                  ),
                  const SizedBox(width: 32.0),
                  TextButton(
                    onPressed: () {
                      wiki.setProject('Wikibooks');
                      wiki.setUrl('https://incubator.wikimedia.org');
                      wiki.setColor('0xff9b00a1');
                      controller.loadRequest(Uri.parse(
                          'https://incubator.wikimedia.org/wiki/Wb/nia/Olayama'));
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(int.parse(wiki.color))))),
                    ),
                    child: const Text(
                      'wikibooks',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                        // color: Color(0xff9b00a1),
                      ),
                    ).tr(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
