import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/home_screen.dart';
import 'package:wikinias/wiki_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'welcome',
              style: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ).tr(),
            Text(
              'select_wiki',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ).tr(),
            const SizedBox(height: 50.0),
            Consumer<WikiProvider>(
              builder: (context, wiki, child) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      wiki.setProject('Wikipedia');
                      wiki.setUrl('https://nia.wikipedia.org');
                      wiki.setColor('0xff121298');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(
                            url: 'https://nia.wikipedia.org',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'wikipedia',
                      style: const TextStyle(color: Colors.white70),
                    ).tr(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff121298)),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      wiki.setProject('Wiktionary');
                      wiki.setUrl('https://nia.wiktionary.org');
                      wiki.setColor('0xffe9d6ae');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(
                            url: 'https://nia.wiktionary.org',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'wiktionary',
                      style: const TextStyle(color: Colors.red),
                    ).tr(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffe9d6ae),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      wiki.setProject('Wikibooks');
                      wiki.setUrl('https://incubator.wikimedia.org');
                      wiki.setColor('0xff9b00a1');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(
                            url:
                                'https://incubator.wikimedia.org/wiki/Wb/nia/Olayama',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'wikibooks',
                      style: const TextStyle(color: Colors.white70),
                    ).tr(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff9b00a1)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
            const Image(
              image: AssetImage('assets/images/color_bar_nias.png'),
              width: 300,
            ),
            const Spacer(),
            Text(
              'select_language',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ).tr(),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    context.setLocale(const Locale('en'));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
