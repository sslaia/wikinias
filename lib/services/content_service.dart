import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class ContentService {
  final SharedPreferences _prefs;
  final Random _random = Random();

  ContentService(this._prefs);

  // DYK section
  Future<Map<String, dynamic>> getFeaturedDyk() async {
    return _getDailyContent(
      assetPath: 'assets/data/featured_dyks_data.json',
      dateKey: 'featured_dyk_date',
      contentKey: 'featured_dyk_content',
    );
  }

  // Featured Article section
  Future<Map<String, dynamic>> getFeaturedArticle() async {
    return _getDailyContent(
      assetPath: 'assets/data/featured_articles_data.json',
      dateKey: 'featured_article_date',
      contentKey: 'featured_article_content',
    );
  }

  // Featured Story section
  Future<Map<String, dynamic>> getFeaturedStory() async {
    return _getDailyContent(
      assetPath: 'assets/data/featured_stories_data.json',
      dateKey: 'featured_story_date',
      contentKey: 'featured_story_content',
    );
  }

  // Featured Article section
  Future<Map<String, dynamic>> getFeaturedWord() async {
    return _getDailyContent(
      assetPath: 'assets/data/featured_words_data.json',
      dateKey: 'featured_word_date',
      contentKey: 'featured_word_content',
    );
  }

  Future<Map<String, dynamic>> _getDailyContent({
    required String assetPath,
    required String dateKey,
    required String contentKey,
  }) async {
    final today = _getTodayDateString();
    final savedDate = _prefs.getString(dateKey);
    final savedContentString = _prefs.getString(contentKey);

    // Use the saved content
    if (savedDate == today && savedContentString != null) {
      return json.decode(savedContentString) as Map<String, dynamic>;
    }

    // Or generate a new one.
    final List<dynamic> allItems = await _loadJsonAsset(assetPath);
    final newItem = allItems[_random.nextInt(allItems.length)] as Map<String, dynamic>;

    // Save the new item and today's date
    await _prefs.setString(dateKey, today);
    await _prefs.setString(contentKey, json.encode(newItem));

    return newItem;
  }

  /// Loads and decodes a JSON file from the assets folder.
  Future<List<dynamic>> _loadJsonAsset(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString) as List<dynamic>;
  }

  /// Returns the current date as a simple 'YYYY-MM-DD' string.
  String _getTodayDateString() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
