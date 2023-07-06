import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class WikiProvider extends ChangeNotifier {
  static const String _projectKey = 'project';
  static const String _urlKey = 'url';
  static const String _colorKey = 'color';

  late SharedPreferences _preferences;

  String project = '';
  String url = '';
  String color = '';

  WikiProvider() {
    _init();
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
    project = _preferences.getString(_projectKey) ?? 'Wikipedia';
    url = _preferences.getString(_urlKey) ?? 'https://nia.wikipedia.org';
    color = _preferences.getString(_colorKey) ?? '0xff121298';

    if (project.isEmpty) {
      await setProject('Wikipedia');
      await setUrl('https://nia.wikipedia.org');
      await setColor('0xff121298');
    }
  }

  Future<void> setProject(String name) async {
    project = name;
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(_projectKey, name);
    notifyListeners();
  }

  Future<void> setUrl(String name) async {
    url = name;
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(_urlKey, name);
    notifyListeners();
  }

  Future<void> setColor(String name) async {
    color = name;
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(_colorKey, name);
    notifyListeners();
  }
}
