import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/buttons/select_language.dart';
import 'package:wikinias/buttons/select_wiki.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              Text(
                'select_wiki',
                style: const TextStyle(color: Colors.black54),
              ).tr(),
              const SizedBox(height: 30.0),
              SelectWiki(
                  name: 'Wiktionary',
                  url: 'https://nia.m.wiktionary.org',
                  backgroundColor: Color(0xffe9d6ae),
                  label: 'wiktionary',
                  labelColor: Colors.red),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectWiki(
                      name: 'Wikipedia',
                      url: 'https://nia.m.wikipedia.org',
                      backgroundColor: Color(0xff121298),
                      label: 'wikipedia',
                      labelColor: Colors.white70),
                  const SizedBox(width: 8.0),
                  SelectWiki(
                      name: 'Wb/nia/Wikibooks',
                      url: 'https://incubator.m.wikimedia.org',
                      backgroundColor: Color(0xff9b00a1),
                      label: 'wikibooks',
                      labelColor: Colors.white70),
                ],
              ),
              const SizedBox(height: 50.0),
              const Image(
                image: AssetImage('assets/images/color_bar_nias.png'),
                height: 1.0,
              ),
              const Spacer(),
              Text(
                'select_language',
                style: const TextStyle(color: Colors.black54),
              ).tr(),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectLanguage(
                      label: 'english',
                      language: 'en',
                      backgroundColor: Color(0xff9b00a1),
                      labelColor: Color(0xff9b00a1)),
                  const SizedBox(width: 30.0),
                  SelectLanguage(
                      label: 'nias',
                      language: 'id',
                      backgroundColor: Color(0xff121298),
                      labelColor: Color(0xff121298)),
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
