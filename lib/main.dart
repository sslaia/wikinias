import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:wikinias/localizations/nia_material_localizations.dart';
import 'package:wikinias/services/api_service.dart';
import 'package:wikinias/services/app_data_service.dart';
import 'package:wikinias/courses/courses_screen.dart';
import 'package:wikinias/gallery/gallery_screen.dart';
import 'package:wikinias/niaspedia/niaspedia_home_screen.dart';
import 'package:wikinias/providers/font_size_provider.dart';
import 'package:wikinias/providers/settings_provider.dart';
import 'package:wikinias/providers/theme_provider.dart';
import 'package:wikinias/screens/onboarding_screen.dart';
import 'package:wikinias/wikibuku/wikibuku_home_screen.dart';
import 'package:wikinias/wikikamus/wikikamus_home_screen.dart';

late bool onboardingComplete;
late ApiService apiService;
late AppDataService appDataService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  await EasyLocalization.ensureInitialized();

  apiService = ApiService(prefs);
  appDataService = AppDataService(apiService, prefs);

  // Edge-to-edge requirement for Android 15
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('nia'), Locale('id'), Locale('en')],
      startLocale: Locale('nia'),
      fallbackLocale: const Locale('id'),
      path: 'assets/translations',
      child: WikiNias(prefs: prefs),
    ),
  );
}

class WikiNias extends StatelessWidget {
  final SharedPreferences prefs;
  const WikiNias({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        Provider<AppDataService>.value(value: appDataService),
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => FontSizeProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, ThemeProvider>(
          create: (context) => ThemeProvider(context.read<SettingsProvider>()),
          update: (context, settingsProvider, previousThemeProvider) =>
              ThemeProvider(settingsProvider),
        ),
      ],
      child: Consumer2<FontSizeProvider, ThemeProvider>(
        builder: (context, fontSizeProvider, themeProvider, child) {
          final double scale = fontSizeProvider.currentScale;

          const TextTheme baseTextTheme = TextTheme(
            displayLarge: TextStyle(fontSize: 57.0),
            displayMedium: TextStyle(fontSize: 45.0),
            displaySmall: TextStyle(fontSize: 36.0),
            headlineLarge: TextStyle(fontSize: 32.0),
            headlineMedium: TextStyle(fontSize: 28.0),
            headlineSmall: TextStyle(fontSize: 24.0),
            titleLarge: TextStyle(fontSize: 22.0),
            titleMedium: TextStyle(fontSize: 16.0),
            titleSmall: TextStyle(fontSize: 14.0),
            bodyLarge: TextStyle(fontSize: 16.0),
            bodyMedium: TextStyle(fontSize: 14.0),
            bodySmall: TextStyle(fontSize: 12.0),
            labelLarge: TextStyle(fontSize: 14.0),
            labelMedium: TextStyle(fontSize: 12.0),
            labelSmall: TextStyle(fontSize: 11.0),
          );

          final ThemeData lightTheme = themeProvider.getThemeData(
            Brightness.light,
          );
          final ThemeData darkTheme = themeProvider.getThemeData(
            Brightness.dark,
          );

          return MaterialApp(
            title: 'WikiNias',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: lightTheme.copyWith(
              textTheme: lightTheme.textTheme
                  .merge(baseTextTheme)
                  .apply(fontSizeFactor: scale),
            ),
            darkTheme: darkTheme.copyWith(
              textTheme: darkTheme.textTheme
                  .merge(baseTextTheme)
                  .apply(fontSizeFactor: scale),
            ),
            localizationsDelegates: [
              EasyLocalization.of(context)!.delegate,
              const NiaMaterialLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            initialRoute: onboardingComplete ? '/' : '/onboarding',
            routes: {
              '/': (context) => const HomeWrapper(),
              '/niaspedia': (context) => NiaspediaHomeScreen(),
              '/wikikamus': (context) => WikikamusHomeScreen(),
              '/wikibuku': (context) => WikibukuHomeScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/courses': (context) => const CoursesScreen(),
              '/gallery': (context) => const GalleryScreen(),
            },
          );
        },
      ),
    );
  }
}

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final Project selectedProject =
        context.watch<SettingsProvider>().selectedProject;

    switch (selectedProject) {
      case Project.Wikikamus:
        return WikikamusHomeScreen();
      case Project.Wikibuku:
        return WikibukuHomeScreen();
      case Project.Courses:
        return const CoursesScreen();
      case Project.Gallery:
        return const GalleryScreen();
      case Project.Niaspedia:
      return NiaspediaHomeScreen();
    }
  }
}
