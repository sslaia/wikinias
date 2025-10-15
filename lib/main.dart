import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikinias/courses/courses_screen.dart';
import 'package:wikinias/gallery/gallery_screen.dart';
import 'package:wikinias/niaspedia/niaspedia_home_screen.dart';
import 'package:wikinias/providers/font_size_provider.dart';
import 'package:wikinias/providers/settings_provider.dart';
import 'package:wikinias/providers/theme_provider.dart';
import 'package:wikinias/screens/onboarding_screen.dart';
import 'package:wikinias/screens/settings_screen.dart';
import 'package:wikinias/services/content_service.dart';
import 'package:wikinias/services/title_api_service.dart';
import 'package:wikinias/wikibuku/wikibuku_home_screen.dart';
import 'package:wikinias/wikikamus/wikikamus_home_screen.dart';

late bool onboardingComplete;
late String selectedRoute;
late ContentService contentService;
late TitleApiService titleApiService;
// late GalleryApiService galleryApiService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  selectedRoute = prefs.getString('selected_route') ?? '/';
  await EasyLocalization.ensureInitialized();

  contentService = ContentService(prefs);
  titleApiService = TitleApiService(prefs);
  // galleryApiService = GalleryApiService(prefs);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id')],
      startLocale: Locale('id'),
      fallbackLocale: const Locale('en'),
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
        // Provider<GalleryApiService>.value(value: galleryApiService),
        Provider<TitleApiService>.value(value: titleApiService),
        Provider<ContentService>.value(value: contentService),
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
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            initialRoute: onboardingComplete ? selectedRoute : '/onboarding',
            routes: {
              '/': (context) => NiaspediaHomeScreen(),
              '/wikikamus': (context) => WikikamusHomeScreen(),
              '/wikibuku': (context) => WikibukuHomeScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/courses': (context) => const CoursesScreen(),
              '/gallery': (context) => const GalleryScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
