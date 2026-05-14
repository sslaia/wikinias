import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/wiki_utils.dart';

class CommonsService {
  static const String _baseUrl = 'https://commons.wikimedia.org/w/api.php';

  static Future<Map<String, dynamic>?> fetchImageInfo(String fileName) async {
    final url = Uri.parse('$_baseUrl?action=query&titles=$fileName&prop=imageinfo&iiprop=url|extmetadata&format=json&origin=*');

    try {
      final response = await http.get(url, headers: WikiUtils.uaHeaders).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pages = data['query']?['pages'] as Map<String, dynamic>?;
        if (pages != null && pages.isNotEmpty) {
          final pageId = pages.keys.first;
          final imageInfo = pages[pageId]?['imageinfo'] as List<dynamic>?;
          if (imageInfo != null && imageInfo.isNotEmpty) {
            return imageInfo.first as Map<String, dynamic>;
          }
        }
      }
    } catch (e) {
      print('Error fetching image info: $e');
    }
    return null;
  }

  static String getThumbnailUrl(String fileName, {int width = 900}) {
    return 'https://commons.wikimedia.org/wiki/Special:FilePath/$fileName?width=$width';
  }

  static String getOriginalUrl(String fileName) {
    return 'https://commons.wikimedia.org/wiki/Special:FilePath/$fileName';
  }
}
