import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/gallery_item.dart';
import 'app_state.dart';

final galleryDataProvider =
    FutureProvider<Map<String, List<GalleryItem>>>((ref) async {
  final langCode = ref.watch(languageProvider);
  Map<String, dynamic> jsonData;

  const onlineUrl =
      'https://raw.githubusercontent.com/sslaia/wikinias/main/assets/data/gallery.json';

  try {
    // Try fetching online version first
    final response = await http
        .get(Uri.parse(onlineUrl))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load online gallery');
    }
  } catch (e) {
    // Fallback to local asset
    final String jsonString =
        await rootBundle.loadString('assets/data/gallery.json');
    jsonData = jsonDecode(jsonString);
  }

  final Map<String, List<GalleryItem>> galleryData = {};

  final Map<String, dynamic>? langData = jsonData[langCode];

  if (langData != null) {
    langData.forEach((key, value) {
      if (value is List) {
        galleryData[key] =
            value.map((item) => GalleryItem.fromJson(item)).toList();
      }
    });
  }

  return galleryData;
});

class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() {
    final galleryData = ref.watch(galleryDataProvider).value;
    if (galleryData != null && galleryData.isNotEmpty) {
      return galleryData.keys.first;
    }
    return null;
  }

  void setCategory(String category) {
    state = category;
  }
}

final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String?>(() {
  return SelectedCategoryNotifier();
});
