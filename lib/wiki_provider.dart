import 'package:flutter/foundation.dart';

class WikiProvider extends ChangeNotifier {
  String? _projectValue;
  String? _urlValue;
  String? _colorValue;

  String get project {
    return _projectValue ?? 'Wikipedia';
  }

  String get url {
    return _urlValue ?? 'https://nia.m.wikipedia.org/wiki/';
  }

  String get color {
    return _colorValue ?? 'Color(0xff121298)';
  }

  setWiki(String value) {
    if (value == 'Wikibooks') {
      _projectValue = 'Wikibooks';
      _urlValue = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
      _colorValue = 'Color(0xff9b00a1)';
    } else if (value == 'Wiktionary') {
      _projectValue = 'Wiktionary';
      _urlValue = 'https://nia.m.wiktionary.org/wiki/';
      _colorValue = 'Color(0xffe9d6ae)';
    } else {
      _projectValue = 'Wikipedia';
      _urlValue = 'https://nia.m.wikipedia.org/wiki/';
      _colorValue = 'Color(0xff121298)';
    }
    notifyListeners();
  }
}
