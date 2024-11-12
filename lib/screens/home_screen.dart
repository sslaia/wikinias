import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Consumer<WikiProvider>(
          builder: (context, wiki, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Wikinias title
              Text(
                'WikiNias',
                style: GoogleFonts.cinzelDecorative(
                  textStyle: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
              ).tr(),
              const SizedBox(height: 30.0),
              // Select wiki
              Text(
                'select_wiki',
                style: const TextStyle(color: Colors.black54),
              ).tr(),
              const SizedBox(height: 10.0),
              // Wiktionary
              ElevatedButton(
                onPressed: () async {
                  wiki.setProject('Wiktionary', 'https://nia.m.wiktionary.org', Color(0xffe9d6ae));
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wiktionary');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xffe9d6ae)),
                child: Text('wiktionary', style: TextStyle(color: Colors.black87)).tr(),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Wikipedia
                  ElevatedButton(
                    onPressed: () async {
                      wiki.setProject('Wikipedia', 'https://nia.m.wikipedia.org', Color(0xff121298));
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/wikipedia');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xff121298)),
                    child: Text('wikipedia', style: TextStyle(color: Colors.white70)).tr(),
                  ),
                  const SizedBox(width: 8.0),
                  // Wikibooks
                  ElevatedButton(
                    onPressed: () async {
                      wiki.setProject('Wb/nia/Wikibooks', 'https://incubator.m.wikimedia.org', Color(0xff9b00a1));
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/wikibooks');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xff9b00a1)),
                    child: Text('wikibooks', style: TextStyle(color: Colors.white70)).tr(),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              const Image(
                image: AssetImage('assets/images/color_bar_nias.png'),
                height: 1.0,
              ),
              const Spacer(),
              // Select language
              Text(
                'select_language',
                style: const TextStyle(color: Colors.black54),
              ).tr(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // English
                  TextButton(
                    onPressed: () {
                      context.setLocale(Locale('en'));
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    child: Text('english', style: TextStyle(color: Color(0xff9b00a1))).tr(),
                  ),
                  const SizedBox(width: 10.0),
                  // Nias
                  TextButton(
                    onPressed: () {
                      context.setLocale(Locale('id'));
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xff121298)))),
                    ),
                    child: Text('nias', style: TextStyle(color: Color(0xff121298))).tr(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
