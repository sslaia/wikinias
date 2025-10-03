import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/article.dart';
import '../models/dyk.dart';
import '../models/recent_changes.dart';
import '../models/story.dart';
import '../models/word.dart';

class WikiniasApiService {
  // fetch the list of local dyk
  Future<List<Dyk>> fetchDyks() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/dyks_data.json',
      );
      return compute(parseDyks, jsonString);
    } catch (e) {
      return [];
    }
  }

  // fetch the random local dyk
  Future<Dyk?> fetchRandomDyk() async {
    try {
      final List<Dyk> dyks = await fetchDyks();
      if (dyks.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(dyks.length);
        return dyks[randomIndex];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // fetch the list of local articles
  Future<List<Article>> fetchArticles() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/articles_data.json',
      );
      return compute(parseArticles, jsonString);
    } catch (e) {
      return [];
    }
  }

  // fetch a random local article
  Future<Article?> fetchRandomArticle() async {
    try {
      final List<Article> articles = await fetchArticles();
      if (articles.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(articles.length);
        return articles[randomIndex];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

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

  // fetch the list of local words
  Future<List<Word>> fetchWords() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/words_data.json',
      );
      return compute(parseWords, jsonString);
    } catch (e) {
      return [];
    }
  }

  // fetch a random local word
  Future<Word?> fetchRandomWord() async {
    try {
      final List<Word> words = await fetchWords();
      if (words.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(words.length);
        return words[randomIndex];
      } else {
        return null;
      }
    } catch (e) {
      return null;
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

  // fetch the list of local stories
  Future<List<Story>> fetchStories() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/stories_data.json',
      );
      return compute(parseStories, jsonString);
    } catch (e) {
      return [];
    }
  }

  // fetch the random local story
  Future<Story?> fetchRandomStory() async {
    try {
      final List<Story> stories = await fetchStories();
      if (stories.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(stories.length);
        return stories[randomIndex];
      } else {
        return null;
      }
    } catch (e) {
      return null;
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

Future<List<Dyk>> parseDyks(String jsonString) async {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Dyk.fromJson(json)).toList();
}

Future<List<Article>> parseArticles(String jsonString) async {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Article.fromJson(json)).toList();
}

Future<List<Story>> parseStories(String jsonString) async {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Story.fromJson(json)).toList();
}

Future<List<Word>> parseWords(String jsonString) async {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Word.fromJson(json)).toList();
}
