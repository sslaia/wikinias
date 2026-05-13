import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_type.dart';
import 'shared_prefs_provider.dart';

/// Notifier for the current project type (Wikipedia, Wiktionary, Wikibooks)
class AppStateNotifier extends Notifier<ProjectType> {
  @override
  ProjectType build() {
    return ProjectType.wikipedia;
  }

  void setProject(ProjectType project, String langCode) {
    if (project.isSupported(langCode)) {
      state = project;
    }
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, ProjectType>(() {
  return AppStateNotifier();
});

/// Notifier for the application language
class LanguageNotifier extends Notifier<String> {
  static const _languageKey = 'selected_language_code';

  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_languageKey) ?? 'nia';
  }

  void setLanguage(String code) {
    if (state != code) {
      state = code;
      ref.read(sharedPreferencesProvider).setString(_languageKey, code);
      
      // Safety check: if current project is not supported in new language, revert to Wikipedia
      final currentProject = ref.read(appStateProvider);
      if (!currentProject.isSupported(code)) {
        ref.read(appStateProvider.notifier).setProject(ProjectType.wikipedia, code);
      }
    }
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, String>(() {
  return LanguageNotifier();
});
