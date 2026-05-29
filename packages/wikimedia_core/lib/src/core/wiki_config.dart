import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WikiConfig {
  static Map<String, dynamic> _rules = {};
  static late String _appName;
  static bool _isInitialized = false;

  /// Wikimedia requires a descriptive User-Agent
  static Map<String, String> get uaHeaders => {
    'User-Agent': 'WikiNias/1.1.0 (https://sslaia.github.io/$_appName; slaia@yahoo.com) Generic/1.0',
  };

  /// Initialize the WikiConfig. This fetches rules from the remote GitHub repository,
  /// with a fallback to the local asset if the network request fails.
  static Future<void> init({required String appName}) async {
    if (_isInitialized) return;
    _appName = appName;

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'wiki_config_rules_$_appName';

    try {
      final url = 'https://raw.githubusercontent.com/sslaia/$_appName/refs/heads/main/assets/data/html_rules.json';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        _rules = jsonDecode(response.body);
        await prefs.setString(cacheKey, response.body);
        _isInitialized = true;
        return;
      }
    } catch (e) {
      // Fallback to cache or local asset
    }

    // Try cache
    final cached = prefs.getString(cacheKey);
    if (cached != null) {
      try {
        _rules = jsonDecode(cached);
        _isInitialized = true;
        return;
      } catch (_) {}
    }

    // Try local asset as final fallback
    try {
      final jsonString = await rootBundle.loadString('assets/data/html_rules.json');
      _rules = jsonDecode(jsonString);
    } catch (e) {
      _rules = {};
    }
    _isInitialized = true;
  }

  /// Get the full rules map for a language code and project
  static Map<String, dynamic>? getRules(String languageCode, String projectStr) {
    return _rules[languageCode]?[projectStr] as Map<String, dynamic>?;
  }

  /// Get global rules for a project
  static Map<String, dynamic>? getGlobalRules(String projectStr) {
    return _rules['global']?[projectStr] as Map<String, dynamic>?;
  }

  /// Get the domain for a given language code and project.
  /// Falls back to `<langCode>.<projectStr>.org` if no override is specified.
  static String getDomain(String languageCode, String projectStr) {
    final rules = getRules(languageCode, projectStr);
    if (rules != null && rules.containsKey('domainOverride')) {
      return rules['domainOverride'] as String;
    }
    return '$languageCode.$projectStr.org';
  }

  /// Get the API prefix for a given language code and project.
  /// Falls back to an empty string.
  static String getApiPrefix(String languageCode, String projectStr) {
    final rules = getRules(languageCode, projectStr);
    if (rules != null && rules.containsKey('apiPrefix')) {
      return rules['apiPrefix'] as String;
    }
    return '';
  }

  /// Get the processing flags for a given language code and project.
  static List<String> getProcessingFlags(String languageCode, String projectStr) {
    final rules = getRules(languageCode, projectStr);
    if (rules != null && rules['processingFlags'] != null && rules['processingFlags'] is List) {
      return (rules['processingFlags'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  /// Check if a specific processing flag exists
  static bool hasProcessingFlag(String languageCode, String projectStr, String flag) {
    return getProcessingFlags(languageCode, projectStr).contains(flag);
  }

  /// Get combined rule list (e.g., 'remove' or 'hide') from both global and project specific rules
  static List<String> getCombinedRulesList(String languageCode, String projectStr, String key) {
    final list = <String>[];
    final globalRules = getGlobalRules(projectStr);
    if (globalRules != null && globalRules[key] != null && globalRules[key] is List) {
      list.addAll((globalRules[key] as List).map((e) => e.toString()));
    }
    final projectRules = getRules(languageCode, projectStr);
    if (projectRules != null && projectRules[key] != null && projectRules[key] is List) {
      list.addAll((projectRules[key] as List).map((e) => e.toString()));
    }
    return list;
  }
}
