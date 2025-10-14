import 'package:flutter/material.dart';
import 'package:wikinias/providers/settings_provider.dart';

import '../theme/wikinias_theme.dart';

class ThemeProvider with ChangeNotifier {
  final SettingsProvider _settingsProvider;

  Project? _lastProject;

  ThemeProvider(this._settingsProvider) {
    _settingsProvider.addListener(_onSettingsChanged);
    _lastProject = _settingsProvider.selectedProject;
  }

  void _onSettingsChanged() {
    if (_settingsProvider.selectedProject != _lastProject) {
      _lastProject = _settingsProvider.selectedProject;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _settingsProvider.removeListener(_onSettingsChanged);
    super.dispose();
  }

  ThemeData getThemeData(Brightness brightness) {
    final WikiniasTheme wikiniasTheme = _getWikiniasTheme();

    final Color seedColor = brightness == Brightness.light
        ? wikiniasTheme.lightSeed
        : wikiniasTheme.darkSeed;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(useMaterial3: true, colorScheme: colorScheme);
  }

  WikiniasTheme _getWikiniasTheme() {
    switch (_settingsProvider.selectedProject) {
      case Project.Niaspedia:
        return WikiniasTheme.niaspedia;
      case Project.Wikikamus:
        return WikiniasTheme.wikikamus;
      case Project.Wikibuku:
        return WikiniasTheme.wikibuku;
      case Project.Courses:
        return WikiniasTheme.wikibuku;
      case Project.Gallery:
        return WikiniasTheme.wikibuku;
      }
  }
}
