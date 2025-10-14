import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TitleApiService {
  final SharedPreferences _prefs;

  static const String _remoteDataUrl = 'https://raw.githubusercontent.com/sslaia/wikinias/refs/heads/main/assets/data/titles_data.json';
  static const String _titlesCacheKey = 'cached_titles_data.json';

  TitleApiService(this._prefs);

  Future<void> forceUpdateTitlesFromRemote() async {
    try {
      final response = await http.get(Uri.parse(_remoteDataUrl));

      if (response.statusCode == 200) {
        final String jsonString = utf8.decode(response.bodyBytes);
        json.decode(jsonString);

        await _prefs.setString(_titlesCacheKey, jsonString);
      } else {
        throw Exception(
            'Failed to load titles from GitHub. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Failed to update titles. Please check your internet connection.');
    }
  }

  Future<Map<String, List<String>>> loadTitles() async {
    String? jsonString = _prefs.getString(_titlesCacheKey);
    String source;

    if (jsonString != null) {
      source = 'cache';
    } else {
      jsonString = await rootBundle.loadString('assets/data/titles_data.json');
      source = 'asset';
    }

    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      return jsonData.map(
            (key, value) {
          final List<String> titleList = List<String>.from(value);
          return MapEntry(key, titleList);
        },
      );
    } catch (e) {
      if (source == 'cache') {
        await _prefs.remove(_titlesCacheKey);
        return loadTitles();
      }
      throw Exception('Failed to parse project titles from bundled asset.');
    }
  }

  String? getRandomTitle(Map<String, List<String>> titles, String project) {
    if (!titles.containsKey(project)) {
      return null;
    }

    final List<String> projectTitles = titles[project]!;
    if (projectTitles.isEmpty) {
      return null;
    }

    final random = Random();
    final index = random.nextInt(projectTitles.length);
    return projectTitles[index];
  }
}