import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/recent_changes.dart';

class WikiniasApiService {
  // fetch the content of the online Niaspedia page
  Future<String> fetchNiaspediaPage(String title) async {
    final uri = Uri.https('nia.m.wikipedia.org', '/w/api.php', {
      // action=parse&page=$title&prop=text&formatversion=2&format=json
      'action': 'parse',
      'page': title,
      'prop': 'text',
      'formatversion': '2',
      'format': 'json',
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final pageContent = data['parse']['text'];
        return pageContent;
      } else {
        throw Exception(
          'Failed to load the page. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // fetch the content of online Wikikamus page
  Future<String> fetchWikikamusPage(String title) async {
    final uri = Uri.https('nia.m.wiktionary.org', '/w/api.php', {
      // action=parse&page=$title&prop=text&formatversion=2&format=json
      'action': 'parse',
      'page': title,
      'prop': 'text',
      'formatversion': '2',
      'format': 'json',
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final pageContent = data['parse']['text'];
        return pageContent;
      } else {
        throw Exception(
          'Failed to load the page. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // fetch the content of online Wikibuku page
  Future<String> fetchWikibukuPage(String title) async {
    final uri = Uri.https('incubator.m.wikimedia.org', '/w/api.php', {
      // action=parse&page=$title&prop=text&formatversion=2&format=json
      'action': 'parse',
      'page': title,
      'prop': 'text',
      'formatversion': '2',
      'format': 'json',
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final pageContent = data['parse']['text'];
        return pageContent;
      } else {
        throw Exception(
          'Failed to load the page. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<List<RecentChanges>> fetchNiaspediaRecentChanges({
    int limit = 50,
  }) async {
    final uri = Uri.https('nia.m.wikipedia.org', '/w/api.php', {
      'action': 'query',
      'list': 'recentchanges',
      'rcprop': 'title|ids|sizes|flags|user|comment',
      'rclimit': limit.toString(),
      'format': 'json',
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return compute(_parseRecentChanges, response.body);
      } else {
        throw Exception(
          'Failed to load recent changes: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching recent changes: $e');
    }
  }

  Future<List<RecentChanges>> fetchWikikamusRecentChanges({
    int limit = 50,
  }) async {
    final uri = Uri.https('nia.m.wiktionary.org', '/w/api.php', {
      'action': 'query',
      'list': 'recentchanges',
      'rcprop': 'title|ids|sizes|flags|user|comment',
      'rclimit': limit.toString(),
      'format': 'json',
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return compute(_parseRecentChanges, response.body);
      } else {
        throw Exception(
          'Failed to load recent changes: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching recent changes: $e');
    }
  }

  Future<List<RecentChanges>> fetchWikibukuRecentChanges({
    int limit = 50,
  }) async {
    final uri = Uri.https('incubator.m.wikimedia.org', '/w/api.php', {
      'action': 'query',
      'list': 'recentchanges',
      'rcprop': 'title|ids|sizes|flags|user|comment',
      'rclimit': limit.toString(),
      'format': 'json',
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return compute(_parseRecentChanges, response.body);
      } else {
        throw Exception(
          'Failed to load recent changes: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching recent changes: $e');
    }
  }
}

Future<List<RecentChanges>> _parseRecentChanges(String responseBody) async {
  final Map<String, dynamic> data = jsonDecode(responseBody);

  if (data.containsKey('query') && data['query'].containsKey('recentchanges')) {
    final List<dynamic> changesList = data['query']['recentchanges'];
    return changesList
        .map((jsonItem) => RecentChanges.fromJson(jsonItem))
        .toList();
  } else {
    throw Exception('Unexpected JSON structure from Wikipedia API');
  }
}
