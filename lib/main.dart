import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localizations/nia_material_localizations.dart';
import 'providers/shared_prefs_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/font_size_provider.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

class WikiHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'WikiNias/2.5.0 (https://sslaia.github.io/wikinias; slaia@yahoo.com) Flutter/3.x';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Set global User-Agent to comply with Wikimedia's API policy and avoid 429 errors.
  HttpOverrides.global = WikiHttpOverrides();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id'), Locale('nia')],
      startLocale: const Locale('nia'),
      fallbackLocale: const Locale('id'),
      path: 'assets/translations',
      child: ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const WikiNiasApp(),
      ),
    ),
  );
}

class WikiNiasApp extends ConsumerWidget {
  const WikiNiasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProject = ref.watch(appStateProvider);
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final prefs = ref.watch(sharedPreferencesProvider);
    final bool isFirstStart = prefs.getBool('onboarding_completed') ?? false;

    return MaterialApp(
      title: 'WikiNias',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(currentProject, brightness: Brightness.light),
      darkTheme: AppTheme.getTheme(currentProject, brightness: Brightness.dark),
      themeMode: themeMode,
      localizationsDelegates: [
        EasyLocalization.of(context)!.delegate,
        const NiaMaterialLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(fontSize.scale)),
          child: child!,
        );
      },
      home: isFirstStart ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
