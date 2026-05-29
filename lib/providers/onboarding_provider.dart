import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'shared_prefs_provider.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingNotifier(prefs);
});

class OnboardingNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _onboardingKey = 'onboarding_completed';

  OnboardingNotifier(this._prefs) : super(_prefs.getBool(_onboardingKey) ?? false);

  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingKey, true);
    state = true;
  }
}
