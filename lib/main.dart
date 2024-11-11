import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/screens/welcome_screen.dart';
import 'package:wikinias/provider/wiki_provider.dart';
import 'package:wikinias/screens/wikibooks_screen.dart';
import 'package:wikinias/screens/wikipedia_screen.dart';
import 'package:wikinias/screens/wiktionary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      // startLocale: Locale.fromSubtags(languageCode: 'en'),
      child: ChangeNotifierProvider(
        create: (context) => WikiProvider(),
        child: WikiNias(),
      ),
    ),
  );
}

class WikiNias extends StatelessWidget {
  const WikiNias({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff121298)),
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/wikipedia': (context) => WikipediaScreen(),
        '/wiktionary': (context) => WiktionaryScreen(),
        '/wikibooks': (context) => WikibooksScreen(),
      },
    );
  }
}
