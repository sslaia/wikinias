import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gallery_item.dart';

class GalleryApiService {

  final SharedPreferences _prefs;

  static const String _remoteDataUrl = 'https://raw.githubusercontent.com/sslaia/wikinias/refs/heads/main/assets/data/gallery_data.json';
  static const String _cacheKey = 'cached_gallery_data_json';

  GalleryApiService(this._prefs);

  // Fetches the latest gallery data from the remote server
  Future<void> forceUpdateFromRemote() async {
    try {
      final response = await http.get(Uri.parse(_remoteDataUrl));
      if (response.statusCode == 200) {
        final String jsonString = utf8.decode(response.bodyBytes);
        json.decode(jsonString);
        await _prefs.setString(_cacheKey, jsonString);
      } else {
        throw Exception(
            'Failed to load gallery from GitHub. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Failed to update gallery. Please check your internet connection.');
    }
  }

  // Lads gallery dat, prioritizing cached versions over bundled assets
  Future<Map<String, List<GalleryItem>>> loadAllGalleries() async {
    String? jsonString = _prefs.getString(_cacheKey);
    String source = 'cache';

    if (jsonString == null) {
      jsonString = await rootBundle.loadString('assets/data/gallery_data.json');
      source = 'asset';
    }

    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((category, items) {
        final List<GalleryItem> galleryItems = (items as List)
            .map((itemJson) => GalleryItem.fromJson(itemJson as Map<String, dynamic>))
            .toList();
        return MapEntry(category, galleryItems);
      });
    } catch (e) {
      if (source == 'cache') {
        await _prefs.remove(_cacheKey);
        return loadAllGalleries();
      }
      throw Exception('Failed to parse gallery data from bundled asset.');
    }
  }
}
