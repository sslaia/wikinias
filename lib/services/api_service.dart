import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_data_config.dart';

class ApiService {
  final SharedPreferences _prefs;

  ApiService(this._prefs);

  /// Loads data from cache if available, otherwise falls back to bundled assets.
  /// This is the primary method for the UI to get data quickly.
  Future<String> loadData(ApiDataConfig config) async {
    String? jsonString = _prefs.getString(config.cacheKey);
    String source;

    if (jsonString != null && jsonString.isNotEmpty) {
      source = 'cache';
    } else {
      // Fallback to asset if cache is empty
      jsonString = await rootBundle.loadString(config.bundleAssetPath);
      source = 'asset';
    }

    // Validate JSON before returning to prevent parsing errors in the app.
    try {
      json.decode(jsonString);
      return jsonString;
    } catch (e) {
      // If cache is corrupted, remove it and load from the asset as a safe fallback.
      if (source == 'cache') {
        await _prefs.remove(config.cacheKey);
        return rootBundle.loadString(config.bundleAssetPath);
      }
      // If the bundled asset itself is broken, this is a critical development error.
      throw Exception('Failed to parse bundled asset data: ${config.bundleAssetPath}. Error: $e');
    }
  }

  /// Checks if an update is needed and fetches new data from the remote URL.
  /// This should be called in the background, not blocking the UI.
  Future<void> updateDataInBackground(
      {required ApiDataConfig config, required int updateIntervalDays}) async {
    final String lastUpdateKey = '${config.cacheKey}_last_update';
    final int? lastUpdateTimestamp = _prefs.getInt(lastUpdateKey);

    // Check if it's time to update
    final bool needsUpdate = lastUpdateTimestamp == null ||
        DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp)
            .isBefore(DateTime.now().subtract(Duration(days: updateIntervalDays)));

    if (!needsUpdate) {
      return;
    }

    try {
      final response = await http.get(Uri.parse(config.remoteUrl));

      if (response.statusCode == 200) {
        final String jsonString = utf8.decode(response.bodyBytes);
        json.decode(jsonString);

        // Save the new data and update the timestamp
        await _prefs.setString(config.cacheKey, jsonString);
        await _prefs.setInt(lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
      } else {
        // Don't throw an error that crashes the app, just log it.
        // The app will continue using the old data.
        if (kDebugMode) {
          print('Failed to fetch update. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update data due to a network or parsing error: $e');
      }
    }
  }
}
