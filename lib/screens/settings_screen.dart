import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/about_section.dart';
import '../widgets/spacer_color_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const englishSelected = SnackBar(
      content: Text('Set to English interface language!'),
    );
    const niasSelected = SnackBar(
      content: Text("Te'oroma'ö ngawalö duria ba li Niha!"),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 30),
                  // App name
                  Text(
                    'WikiNias',
                    style: TextStyle(
                      fontFamily: 'CinzelDecorative',
                      fontSize: 36.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff121298),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Project selection header
                  Text(
                    'select_wiki',
                    style: const TextStyle(color: Colors.black54),
                  ).tr(),
                  const SizedBox(height: 16.0),
                  // Project selection items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff121298),
                        ),
                        child: Text(
                          'niaspedia',
                          style: TextStyle(
                            fontFamily: 'CinzelDecorative',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ).tr(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/wikibuku');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff9b00a1),
                        ),
                        child: Text(
                          'wikibuku',
                          style: TextStyle(
                            fontFamily: 'CinzelDecorative',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ).tr(),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/wikikamus');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe9d6ae),
                        ),
                        child: Text(
                          'wikikamus',
                          style: TextStyle(
                            fontFamily: 'CinzelDecorative',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ).tr(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/gallery');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                        ),
                        child: Text(
                          'gallery',
                          style: TextStyle(
                            fontFamily: 'CinzelDecorative',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            // color: Colors.black87,
                          ),
                        ).tr(),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/courses');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                        ),
                        child: Text(
                          'courses',
                          style: TextStyle(
                            fontFamily: 'CinzelDecorative',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            // color: Colors.white70,
                          ),
                        ).tr(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SpacerColorBar(imageWidth: 250),
                  const SizedBox(height: 70.0),
                  // Language selection header
                  Text(
                    'select_language',
                    style: const TextStyle(color: Colors.black54),
                  ).tr(),
                  const SizedBox(height: 8.0),
                  // Language selection items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // English
                      TextButton(
                        onPressed: () {
                          context.setLocale(Locale('en'));
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(englishSelected);
                        },
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Color(0xff121298)),
                            ),
                          ),
                        ),
                        child: Text(
                          'english',
                          style: TextStyle(color: Color(0xff9b00a1)),
                        ).tr(),
                      ),
                      const SizedBox(width: 16.0),
                      // Nias
                      TextButton(
                        onPressed: () {
                          context.setLocale(Locale('id'));
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(niasSelected);
                        },
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Color(0xff9b00a1)),
                            ),
                          ),
                        ),
                        child: Text(
                          'nias',
                          style: TextStyle(color: Color(0xff121298)),
                        ).tr(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // About section
                  AboutSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
