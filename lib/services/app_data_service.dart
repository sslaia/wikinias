import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikinias/models/featured_content_item.dart';
import 'package:wikinias/models/courses_content_item.dart';
import 'package:wikinias/models/gallery_content_item.dart';
import 'package:wikinias/models/portal_content_item.dart';
import 'package:wikinias/models/word.dart';
import 'package:wikinias/services/api_data_config.dart';
import 'package:wikinias/services/api_service.dart';

class AppDataService {
  final ApiService _apiService;
  Map<String, dynamic>? _cachedContent;
  final Random _random = Random();

  AppDataService(this._apiService, this._prefs);

  final SharedPreferences _prefs;

  static final featuredContentConfig = ApiDataConfig(
    remoteUrl:
        'https://raw.githubusercontent.com/sslaia/wikinias/refs/heads/main/assets/data/featured_content_data.json',
    cacheKey: 'cached_featured_content',
    bundleAssetPath: 'assets/data/featured_content_data.json',
  );

  static final portalContentConfig = ApiDataConfig(
    remoteUrl:
        'https://raw.githubusercontent.com/sslaia/wikinias/refs/heads/main/assets/data/portal_content_data.json',
    cacheKey: 'cached_portal_data',
    bundleAssetPath: 'assets/data/portal_content_data.json',
  );

  static final coursesContentConfig = ApiDataConfig(
    remoteUrl:
        'https://raw.githubusercontent.com/sslaia/wikinias/refs/heads/main/assets/data/courses_content_data.json',
    cacheKey: 'cached_courses_data',
    bundleAssetPath: 'assets/data/courses_content_data.json',
  );

  static final galleryContentConfig = ApiDataConfig(
    remoteUrl:
        'https://raw.githubusercontent.com/sslaia/wikinias/refs/heads/main/assets/data/gallery_content_data.json',
    cacheKey: 'cached_gallery_data',
    bundleAssetPath: 'assets/data/gallery_content_data.json',
  );

  static final allConfigs = [
    featuredContentConfig,
    portalContentConfig,
    coursesContentConfig,
    galleryContentConfig,
  ];

  /// Triggers a background update check for all data sources
  void triggerBackgroundUpdate() {
    final int userUpdateInterval = _prefs.getInt('update_interval') ?? 30;

    for (final config in allConfigs) {
      _apiService.updateDataInBackground(
        config: config,
        updateIntervalDays: userUpdateInterval,
      );
    }
  }

  /// Loads the portal data
  Future<List<PortalContentItem>> loadPortalData() async {
    try {
      final jsonString = await _apiService.loadData(portalContentConfig);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((jsonItem) => PortalContentItem.fromJson(jsonItem))
          .toList();
    } catch (e) {
      if (kDebugMode) print('Error loading portal data: $e');
      return [];
    }
  }

  /// Loads the courses data
  Future<List<CoursesContentItem>> loadCoursesData({String? category}) async {
    try {
      final jsonString = await _apiService.loadData(coursesContentConfig);

      final dynamic jsonResponse = json.decode(jsonString);

      final List<dynamic> jsonList = jsonResponse is List
          ? jsonResponse
          : jsonResponse['data'] as List<dynamic>;

      final List<CoursesContentItem> courses = jsonList
          .map((jsonItem) => CoursesContentItem.fromJson(jsonItem))
          .toList();

      // Filter by category if provided
      if (category != null) {
        return courses.where((course) => course.category == category).toList();
      }
      return courses;
    } catch (e) {
      if (kDebugMode) print('Error loading course data: $e');
      return [];
    }
  }
  // Future<List<CoursesContentItem>> loadCoursesData() async {
  //   try {
  //     final jsonString = await _apiService.loadData(coursesContentConfig);
  //     final List<dynamic> jsonList = json.decode(jsonString);
  //     return jsonList.map((jsonItem) => CoursesContentItem.fromJson(jsonItem)).toList();
  //   } catch (e) {
  //     if (kDebugMode) print('Error loading courses data: $e');
  //     return [];
  //   }
  // }

  /// Loads the gallery data
  Future<List<GalleryContentItem>> loadGalleryData({String? category}) async {
    try {
      final jsonString = await _apiService.loadData(galleryContentConfig);

      final dynamic jsonResponse = json.decode(jsonString);

      final List<dynamic> jsonList = jsonResponse is List
          ? jsonResponse
          : jsonResponse['data'] as List<dynamic>;

      final List<GalleryContentItem> galleries = jsonList
          .map((jsonItem) => GalleryContentItem.fromJson(jsonItem))
          .toList();

      // Filter by category if provided
      if (category != null) {
        return galleries
            .where((gallery) => gallery.category == category)
            .toList();
      }
      return galleries;
    } catch (e) {
      if (kDebugMode) print('Error loading gallery data: $e');
      return [];
    }
  }

  /// Loads the entire featured content from cache or asset.
  Future<Map<String, dynamic>> _loadFeaturedContent() async {
    if (_cachedContent != null) return _cachedContent!;
    final jsonString = await _apiService.loadData(featuredContentConfig);
    _cachedContent = json.decode(jsonString);
    return _cachedContent!;
  }

  /// Helper method to get a daily item
  Future<Map<String, dynamic>?> _getDailyItem({
    required String listKey,
    required String dateKey,
    required String contentKey,
  }) async {
    final today = _getTodayDateString();
    final savedDate = _prefs.getString(dateKey);
    final savedContentString = _prefs.getString(contentKey);

    if (savedDate == today && savedContentString != null) {
      return json.decode(savedContentString) as Map<String, dynamic>;
    }

    final content = await _loadFeaturedContent();
    final List<dynamic> allItems = content[listKey] as List<dynamic>? ?? [];

    if (allItems.isEmpty) {
      return null;
    }

    final newItem =
        allItems[_random.nextInt(allItems.length)] as Map<String, dynamic>;

    await _prefs.setString(dateKey, today);
    await _prefs.setString(contentKey, json.encode(newItem));

    return newItem;
  }

  // Gets the DIY item for the current day
  Future<FeaturedContentItem?> getDailyDyk() async {
    try {
      final dailyItemJson = await _getDailyItem(
        listKey: 'dyk',
        dateKey: 'daily_dyk_date',
        contentKey: 'daily_dyk_content',
      );

      if (dailyItemJson == null) return null;

      return FeaturedContentItem.fromJson(dailyItemJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting daily DYK: $e');
      }
      return null;
    }
  }

  // Get featured Article for the current day
  Future<FeaturedContentItem?> getDailyArticle() async {
    try {
      final dailyItemJson = await _getDailyItem(
        listKey: 'articles',
        dateKey: 'daily_article_date',
        contentKey: 'daily_article_content',
      );

      if (dailyItemJson == null) return null;

      return FeaturedContentItem.fromJson(dailyItemJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting daily article: $e');
      }
      return null;
    }
  }

  // Get featured Story for the current day
  Future<FeaturedContentItem?> getDailyStory() async {
    try {
      final dailyItemJson = await _getDailyItem(
        listKey: 'stories',
        dateKey: 'daily_story_date',
        contentKey: 'daily_story_content',
      );

      if (dailyItemJson == null) return null;

      return FeaturedContentItem.fromJson(dailyItemJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting daily story: $e');
      }
      return null;
    }
  }

  // Get featured Word for the current day
  Future<Word?> getDailyWord() async {
    try {
      final dailyItemJson = await _getDailyItem(
        listKey: 'words',
        dateKey: 'daily_word_date',
        contentKey: 'daily_word_content',
      );

      if (dailyItemJson == null) return null;

      return Word.fromJson(dailyItemJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting daily featured word: $e');
      }
      return null;
    }
  }

  /// Returns the current date as a simple 'YYYY-MM-DD' string.
  String _getTodayDateString() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  /// Forces an immediate background update by clearing the last update timestamp
  Future<void> forceUpdate() async {
    if (kDebugMode) {
      print("Force Update: Clearing timestamps for all data sources.");
    }
    for (final config in allConfigs) {
      final String lastUpdateKey = '${config.cacheKey}_last_update';
      await _prefs.remove(lastUpdateKey);
    }
    triggerBackgroundUpdate();
  }
}
