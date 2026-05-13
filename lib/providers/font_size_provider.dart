import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_prefs_provider.dart';

enum AppFontSize {
  small('Small', 1.0),
  normal('Default', 1.2),
  large('Large', 1.4),
  extraLarge('Extra Large', 1.6);

  final String label;
  final double scale;

  const AppFontSize(this.label, this.scale);

  static AppFontSize fromName(String name) {
    return AppFontSize.values.firstWhere(
      (e) => e.name == name,
      orElse: () => AppFontSize.normal,
    );
  }
}

class FontSizeNotifier extends Notifier<AppFontSize> {
  static const _fontSizeKey = 'app_font_size';

  @override
  AppFontSize build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedName = prefs.getString(_fontSizeKey);
    if (savedName != null) {
      return AppFontSize.fromName(savedName);
    }
    return AppFontSize.normal;
  }

  void setFontSize(AppFontSize size) {
    state = size;
    ref.read(sharedPreferencesProvider).setString(_fontSizeKey, size.name);
  }
}

final fontSizeProvider = NotifierProvider<FontSizeNotifier, AppFontSize>(() {
  return FontSizeNotifier();
});
