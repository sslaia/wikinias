import 'package:flutter/material.dart';

class WikiProvider extends ChangeNotifier {
  String _name = 'Wikipedia';
  String _url = 'https://www.wikipedia.org/';
  Color _color = Color(0xff121298);

  String get name => _name;
  String get url => _url;
  Color get color => _color;

  void setProject(String name, String url, Color color) {
    _name = name;
    _url = url;
    _color = color;
    notifyListeners();
  }
}
