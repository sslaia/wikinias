import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeProvider with ChangeNotifier {
  static const double _defaultFontSize = 14.0;

  static const double _smallScale = 0.8;
  static const double _normalScale = 1.0;
  static const double _largeScale = 1.2;
  static const double _extraLargeScale = 1.4;

  double _currentScale = _normalScale;

  FontSizeProvider() {
    loadFontSize();
  }
  
  double get currentScale => _currentScale;

  double get scaledFontSize => _defaultFontSize * _currentScale;

  static final Map<String, double> fontScales = {
    'small': _smallScale,
    'normal': _normalScale,
    'large': _largeScale,
    'extra_large': _extraLargeScale
  };

  Future<void> setFontSize(String scaleName) async {
    final scale = fontScales[scaleName];
    if (scale == null) return;

    _currentScale = scale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('font_size_scale', scaleName);

    notifyListeners();
  }

  Future<void> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedScaleName = prefs.getString('font_size_scale') ?? 'Normal';

    _currentScale = fontScales[savedScaleName] ?? _normalScale;

    notifyListeners();
  }
}
