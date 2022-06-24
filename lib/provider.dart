import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WikiProvider extends ChangeNotifier {
  String? _project;
  String? _url;

  String get project {
    return _project ?? 'Wikipedia';
  }

  String get url {
    return _url ?? 'https://nia.m.wikipedia.org/wiki/';
  }

  setWiki(String value) {
    if (value == 'Wikibooks') {
      _project = 'Wikibooks';
      _url = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
    } else if (value == 'Wiktionary') {
      _project = 'Wiktionary';
      _url = 'https://nia.m.wiktionary.org/wiki/';
    } else {
      _project = 'Wikipedia';
      _url = 'https://nia.m.wikipedia.org/wiki/';
    }
    notifyListeners();
  }

}
