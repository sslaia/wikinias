import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wikimedia_core/wikimedia_core.dart';
import 'shared_prefs_provider.dart';

/// Notifier for the current project type (Wikipedia, Wiktionary, Wikibooks)
class AppStateNotifier extends Notifier<ProjectType> {
  static const _projectKey = 'selected_project_type';

  @override
  ProjectType build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final projectStr = prefs.getString(_projectKey);
    if (projectStr != null) {
      try {
        return ProjectType.values.firstWhere((e) => e.toString() == projectStr);
      } catch (_) {}
    }
    return ProjectType.wikipedia;
  }

  void setProject(ProjectType project, String langCode) {
    if (project.isSupported(langCode)) {
      state = project;
      ref.read(sharedPreferencesProvider).setString(_projectKey, project.toString());
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
    return prefs.getString(_languageKey) ?? 'id';
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
