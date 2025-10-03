import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/search_result.dart';

class SearchApiService {
  Future<List<SearchResult>> searchNiaspedia(String query) async {
    final Uri url = Uri.https('nia.m.wikipedia.org', '/w/api.php', {
      'action': 'query',
      'list': 'search',
      'srsearch': query,
      'format': 'json',
      'utf8': '1',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return compute(parseSearch, response.body);
    } else {
      throw Exception(
        'Failed to load search results. Status code: ${response.statusCode}',
      );
    }
  }

  Future<List<SearchResult>> searchWikikamus(String query) async {
    final Uri url = Uri.https('nia.m.wiktionary.org', '/w/api.php', {
      'action': 'query',
      'list': 'search',
      'srsearch': query,
      'format': 'json',
      'utf8': '1',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return compute(parseSearch, response.body);
    } else {
      throw Exception(
        'Failed to load search results. Status code: ${response.statusCode}',
      );
    }
  }

  Future<List<SearchResult>> searchWikibuku(String query) async {
    final Uri url = Uri.https('incubator.m.wikimedia.org', '/w/api.php', {
      'action': 'query',
      'list': 'search',
      'srsearch': query,
      'format': 'json',
      'utf8': '1',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return compute(parseWikibukuSearch, response.body);
    } else {
      throw Exception(
        'Failed to load search results. Status code: ${response.statusCode}',
      );
    }
  }
}

Future<List<SearchResult>> parseSearch(String responseBody) async {
  final wikiResponse = wikiResponseFromJson(responseBody);
  return wikiResponse.query?.search.toList() ?? [];
}

bool check(SearchResult result) {
  return result.title.startsWith('Wb/nia');
}

Future<List<SearchResult>> parseWikibukuSearch(String responseBody) async {
  final wikiResponse = wikiResponseFromJson(responseBody);
  final List<SearchResult> searchResults =
      wikiResponse.query?.search.where((result) => check(result)).toList() ??
      [];
  return searchResults;
}
