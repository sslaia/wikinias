import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class WikiProvider extends ChangeNotifier {
  static const String _projectKey = 'project';

  late SharedPreferences _preferences;

  String project = '';

  WikiProvider() {
    _init();
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
    project = _preferences.getString(_projectKey) ?? 'Wikipedia';

    if (project.isEmpty) {
      await setProject('Wikipedia');
    }
  }

  Future<void> setProject(String name) async {
    project = name;
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(_projectKey, name);
    notifyListeners();
  }
}
