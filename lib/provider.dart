import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WikiProvider extends ChangeNotifier {
  SharedPreferences? _prefs;
  String wiki = 'Wiktionary';
  static const String _key = 'wiki';

  // String get wiki => _prefs?.getString(_key) ?? 'Wiktionary';

  WikiProvider() {
    getWiki();
  }

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  getWiki() async {
    await _initPrefs();
    wiki = _prefs?.getString(_key) ?? 'Wiktionary';
    notifyListeners();
  }

  setWiki(String value) async {
    await _initPrefs();
    _prefs!.setString(_key, value);
    notifyListeners();
  }
}