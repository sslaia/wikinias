import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'courses/courses_screen.dart';
import 'gallery/gallery_screen.dart';
import 'niaspedia/niaspedia_home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'wikibuku/wikibuku_home_screen.dart';
import 'wikikamus/wikikamus_home_screen.dart';

late bool onboardingComplete;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id')],
      startLocale: Locale('id'),
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: WikiNias(),
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
        fontFamily: 'Ubuntu',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff121298)),
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: onboardingComplete ? '/settings' : '/onboarding',
      routes: {
        '/': (context) => NiaspediaHomeScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/wikikamus': (context) => WikikamusHomeScreen(),
        '/wikibuku': (context) => WikibukuHomeScreen(),
        '/courses': (context) => CoursesScreen(),
        '/gallery': (context) => GalleryScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
