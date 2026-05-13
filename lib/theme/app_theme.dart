import 'package:flutter/material.dart';
import '../models/project_type.dart';
import '../providers/font_size_provider.dart';

class AppTheme {
  // Link colors (Light mode - standard)
  static const Color linkBlueLight = Color(0xff0645ad);
  static const Color linkRedLight = Color(0xffba0000);

  // Link colors (Dark mode - accessible/desaturated)
  static const Color linkBlueDark = Color(0xffc0bcfc);
  static const Color linkRedDark = Color(0xffa0482f);

  static Color getLinkColor(BuildContext context, {bool isRedLink = false}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (isRedLink) {
      return isDark ? linkRedDark : linkRedLight;
    }
    return isDark ? linkBlueDark : linkBlueLight;
  }

  static ThemeData getTheme(
      ProjectType projectType, {
        Brightness brightness = Brightness.light,
        AppFontSize fontSize = AppFontSize.normal,
      }) {
    final primaryColor = projectType.primaryColor;
    final bool isLight = brightness == Brightness.light;

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
      ),
      useMaterial3: true,
      textTheme: const TextTheme().apply(
        fontSizeFactor: fontSize.scale,
      ),
      appBarTheme: isLight
          ? AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      )
          : const AppBarTheme(),
      floatingActionButtonTheme: isLight
          ? FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      )
          : const FloatingActionButtonThemeData(),
    );
  }
}
