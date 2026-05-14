import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/home_page_section.dart';
import '../models/project_type.dart';
import '../utils/wiki_utils.dart';
import 'home_page_builder.dart';
import 'html_processor.dart';

class WikiApiService {
  static String _getCacheKey(
    ProjectType project,
    String languageCode,
    String pageTitle,
    bool isArticle,
  ) {
    final projectStr = project.name.toLowerCase();
    return isArticle
        ? 'article_${projectStr}_${languageCode}_$pageTitle'
        : 'home_page_${projectStr}_$languageCode';
  }

  static Future<void> clearCache(
    ProjectType project,
    String languageCode,
    String? pageTitle,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isArticle = pageTitle != null && pageTitle.isNotEmpty;
    final cacheKey = _getCacheKey(
      project,
      languageCode,
      pageTitle ?? 'Main Page',
      isArticle,
    );
    await prefs.remove(cacheKey);
    await prefs.remove('${cacheKey}_timestamp');
  }

  static Future<dynamic> fetchPageHtml(
    ProjectType project,
    String languageCode,
    String pageTitle,
    bool isArticle, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = _getCacheKey(project, languageCode, pageTitle, isArticle);
    final cacheTimestampKey = '${cacheKey}_timestamp';

    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh && !isArticle) {
      final cachedTimestampStr = prefs.getString(cacheTimestampKey);
      if (cachedTimestampStr != null) {
        final cachedTimestamp = DateTime.parse(cachedTimestampStr);
        final difference = DateTime.now().difference(cachedTimestamp);
        if (difference.inHours < 24) {
          final cachedData = prefs.getString(cacheKey);
          if (cachedData != null && cachedData.isNotEmpty) {
            try {
              final List<dynamic> jsonList = jsonDecode(cachedData);
              return jsonList.map((e) => HomePageSection.fromJson(e)).toList();
            } catch (e) {
              await prefs.remove(cacheKey);
              await prefs.remove(cacheTimestampKey);
            }
          }
        }
      }
    }

    String domain = '$languageCode.${project.name.toLowerCase()}.org';
    String finalTitle = pageTitle;
    bool useActionApiForHome = false;

    /// Temporary solution while Nias Wikibooks is still in the Incubator
    if (languageCode == 'nia' && project == ProjectType.wikibooks) {
      domain = 'incubator.wikimedia.org';
      useActionApiForHome = true;
      if (pageTitle == 'Main Page') {
        finalTitle = 'Wb/nia/Olayama';
      } else if (!pageTitle.contains('Wb/nia/')) {
        final lowerTitle = pageTitle.toLowerCase();
        if (lowerTitle.startsWith('special:') ||
            lowerTitle.startsWith('spesial:') ||
            lowerTitle.startsWith('mirunggan:') ||
            lowerTitle.startsWith('istimewa:') ||
            lowerTitle.startsWith('istimiwa:') ||
            lowerTitle.startsWith('istimèwa:') ||
            lowerTitle.startsWith('khas:') ||
            lowerTitle.startsWith('husus:')) {
          finalTitle = pageTitle;
        } else if (lowerTitle.startsWith('category:') ||
                   lowerTitle.startsWith('kategori:') ||
                   lowerTitle.startsWith('template:') ||
                   lowerTitle.startsWith('templat:')) {
          final parts = pageTitle.split(':');
          final namespace = parts[0];
          final rest = parts.sublist(1).join(':');
          finalTitle = '$namespace:Wb/nia/$rest';
        } else {
          finalTitle = 'Wb/nia/$pageTitle';
        }
      }
    }

    String url;
    if (isArticle || useActionApiForHome) {
      url =
          'https://$domain/w/api.php?action=parse&page=${Uri.encodeComponent(finalTitle)}&format=json&prop=text|images&mobileformat=1&redirects=1';
    } else {
      url =
          'https://$domain/w/rest.php/v1/page/${Uri.encodeComponent(finalTitle)}/html';
    }

    try {
      final response = await http
          .get(Uri.parse(url), headers: WikiUtils.uaHeaders)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        if (isArticle) {
          final bodyStr = utf8.decode(response.bodyBytes);
          final decoded = jsonDecode(bodyStr);
          String htmlContent = '';
          if (decoded['parse'] != null && decoded['parse']['text'] != null) {
            htmlContent = decoded['parse']['text']['*'] ?? '';

            final processedResult = await HtmlProcessor.processArticleHtml(
              htmlContent,
              languageCode,
              project,
            );

            /// Fetch and append category members if it's a category page
            final bool isCategory =
                finalTitle.contains('Category:') ||
                finalTitle.contains('Kategori:');
            if (isCategory) {
              final categoryHtml = await _fetchCategoryContent(
                domain,
                finalTitle,
                languageCode,
              );
              processedResult['html'] =
                  (processedResult['html'] ?? '') + categoryHtml;
            }

            await prefs.setString(cacheKey, jsonEncode(processedResult));
            await prefs.setString(
              cacheTimestampKey,
              DateTime.now().toIso8601String(),
            );
            return processedResult;
          }
          return {
            'html': '<i>Error: Could not parse article content.</i>',
            'imageUrl': null,
          };
        } else {
          List<int> htmlBytes;
          if (useActionApiForHome) {
            final bodyStr = utf8.decode(response.bodyBytes);
            final decoded = jsonDecode(bodyStr);
            final htmlContent = decoded['parse']?['text']?['*'] ?? '';
            /// Convert the extracted HTML string back to bytes for HomePageBuilder
            htmlBytes = utf8.encode(htmlContent);
          } else {
            htmlBytes = response.bodyBytes;
          }

          final List<HomePageSection> sections = await HomePageBuilder.build(
            htmlBytes,
            languageCode,
            project,
          );

          await prefs.setString(
            cacheKey,
            jsonEncode(sections.map((e) => e.toJson()).toList()),
          );
          await prefs.setString(
            cacheTimestampKey,
            DateTime.now().toIso8601String(),
          );
          return sections;
        }
      } else {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> searchArticles(
    String query,
    String langCode,
    String projectStr,
  ) async {
    String domain = '$langCode.$projectStr.org';
    String searchQuery = query;

    if (langCode == 'nia' && projectStr == 'wikibooks') {
      domain = 'incubator.wikimedia.org';
      searchQuery = 'Wb/nia/$query';
    }

    final url = Uri.parse(
      'https://$domain/w/api.php?action=query&list=search&srsearch=${Uri.encodeComponent(searchQuery)}&format=json&utf8=1',
    );

    try {
      final response = await http.get(url, headers: WikiUtils.uaHeaders).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) throw Exception('Failed to search Wiki');

      /// Fixed: Use utf8.decode for correct character encoding
      final data = json.decode(utf8.decode(response.bodyBytes));

      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(data['query']['search']);

      if (langCode == 'nia' && projectStr == 'wikibooks') {
        for (var result in results) {
          String title = result['title'] as String;
          if (title.startsWith('Wb/nia/')) {
            result['title'] = title.replaceFirst('Wb/nia/', '');
          }
        }
      }

      return results;
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }

  static Future<String> _fetchCategoryContent(
    String domain,
    String categoryTitle,
    String languageCode,
  ) async {
    final url =
        'https://$domain/w/api.php?action=query&list=categorymembers&cmtitle=${Uri.encodeComponent(categoryTitle)}&cmlimit=500&cmprop=title|type|ns&format=json';
    try {
      final response = await http
          .get(Uri.parse(url), headers: WikiUtils.uaHeaders)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final members = data['query']?['categorymembers'] as List?;
        if (members == null || members.isEmpty)
          return '<p><i>This category currently contains no pages or media.</i></p>';

        final subcats = members.where((m) => m['ns'] == 14).toList();
        final pages = members.where((m) => m['ns'] != 14).toList();

        StringBuffer html = StringBuffer(
          '<div class="category-container" style="margin-top: 24px; border-top: 1px solid #eee; padding-top: 16px;">',
        );

        if (subcats.isNotEmpty) {
          String subTitle = 'Subcategories';
          if (languageCode == 'id') subTitle = 'Subkategori';
          if (languageCode == 'nia') subTitle = 'Subkategori';

          html.write(
            '<h3 style="color: #666; font-size: 1.1em;">$subTitle</h3><ul style="list-style-type: none; padding-left: 0;">',
          );
          for (var sub in subcats) {
            final title = sub['title'] as String;
            html.write(
              '<li style="margin-bottom: 8px; font-weight: 500;">📂 <a href="./$title">$title</a></li>',
            );
          }
          html.write('</ul>');
        }

        if (pages.isNotEmpty) {
          String pagesTitle = 'Pages';
          if (languageCode == 'id') pagesTitle = 'Halaman';
          if (languageCode == 'nia') pagesTitle = 'Nga\'örö';

          html.write(
            '<h3 style="color: #666; font-size: 1.1em; margin-top: 24px;">$pagesTitle</h3><ul style="list-style-type: none; padding-left: 0;">',
          );
          for (var page in pages) {
            final title = page['title'] as String;
            html.write(
              '<li style="margin-bottom: 8px;">📄 <a href="./$title">$title</a></li>',
            );
          }
          html.write('</ul>');
        }

        html.write('</div>');
        return html.toString();
      }
    } catch (_) {}
    return '';
  }

  static Future<String?> fetchRandomArticleTitle(
    String langCode,
    String projectStr,
  ) async {
    String domain = '$langCode.$projectStr.org';

    if (langCode == 'nia' && projectStr == 'wikibooks') {
      domain = 'incubator.wikimedia.org';
      try {
        final url = Uri.parse(
          'https://$domain/w/api.php?action=query&list=search&srsearch=prefix:Wb/nia/&srlimit=50&format=json',
        );
        final response = await http
            .get(url, headers: WikiUtils.uaHeaders)
            .timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          final searchResults = data['query']?['search'] as List?;
          if (searchResults != null && searchResults.isNotEmpty) {
            final randomIndex =
                (DateTime.now().millisecondsSinceEpoch % searchResults.length);
            String title = searchResults[randomIndex]['title'] as String;
            if (title.startsWith('Wb/nia/')) {
              title = title.replaceFirst('Wb/nia/', '');
            }
            return title;
          }
        }
      } catch (_) {}
      return null;
    }

    final url = Uri.parse(
      'https://$domain/w/api.php?action=query&list=random&rnnamespace=0&rnlimit=1&format=json',
    );

    try {
      final response = await http.get(url, headers: WikiUtils.uaHeaders).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final randomList = data['query']?['random'] as List?;
        if (randomList != null && randomList.isNotEmpty) {
          return randomList[0]['title'] as String;
        }
      }
    } catch (_) {}
    return null;
  }
}
