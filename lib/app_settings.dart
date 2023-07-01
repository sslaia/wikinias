import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/wiki_provider.dart';

class AppSettings extends StatelessWidget {
  const AppSettings(
      {super.key, required this.context, required this.webViewController});

  final BuildContext context;
  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    String wikipediaHome = 'https://nia.wikipedia.org';
    String wiktionaryHome = 'https://nia.wiktionary.org';
    String wikibooksHome = 'https://incubator.wikimedia.org/wiki/Wb/nia/Olayama';

    return Container(
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
                color: Colors.black),
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
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff9b00a1)))),
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
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff121298)))),
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
            'choose_wiki_project',
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
          ).tr(),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Provider.of<WikiProvider>(context, listen: false)
                      .setProject('Wikipedia');
                  webViewController.loadRequest(Uri.parse(wikipediaHome));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff121298)))),
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
                  Provider.of<WikiProvider>(context, listen: false)
                      .setProject('Wiktionary');
                  webViewController.loadRequest(Uri.parse(wiktionaryHome));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xffe9d6ae)))),
                ),
                child: const Text(
                  'wiktionary',
                  style: TextStyle(
                    color: Color(0xffe9d6ae),
                  ),
                ).tr(),
              ),
              const SizedBox(width: 32.0),
              TextButton(
                onPressed: () {
                  Provider.of<WikiProvider>(context, listen: false)
                      .setProject('Wikibooks');
                  webViewController.loadRequest(Uri.parse(wikibooksHome));
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xff9b00a1)))),
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
        ],
      ),
    );
  }
}
