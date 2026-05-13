import 'package:flutter/material.dart';

enum ProjectType {
  wikipedia,
  wiktionary,
  wikibooks,
}

extension ProjectTypeExtension on ProjectType {
  String get name {
    switch (this) {
      case ProjectType.wikipedia:
        return 'Wikipedia';
      case ProjectType.wiktionary:
        return 'Wiktionary';
      case ProjectType.wikibooks:
        return 'Wikibooks';
    }
  }

  Color get primaryColor {
    switch (this) {
      case ProjectType.wikipedia:
        return const Color(0xFF121298); // Indigo
      case ProjectType.wiktionary:
        return const Color(0xFFFF5722); // Deep Orange
      case ProjectType.wikibooks:
        return const Color(0xFF9B00A1); // Purple
    }
  }

  String get homeHeroImagePath {
    switch (this) {
      case ProjectType.wikipedia:
        return 'assets/images/woman_reading_a_book_on_lap.webp';
      case ProjectType.wiktionary:
        return 'assets/images/rai.webp';
      case ProjectType.wikibooks:
        return 'assets/images/adu-sarambia.webp';
    }
  }

  String get articleHeroImagePath {
    switch (this) {
      case ProjectType.wikipedia:
        return "assets/images/woman_reading_a_book_on_lap.webp";
      case ProjectType.wiktionary:
        return 'assets/images/rai.webp';
      case ProjectType.wikibooks:
        return 'assets/images/adu-sarambia.webp';
    }
  }

  bool isSupported(String langCode) {
    if (this == ProjectType.wikibooks && (langCode == 'en' || langCode == 'id')) {
      return false;
    }
    if (this == ProjectType.wiktionary && (langCode == 'en' || langCode == 'id')) {
      return false;
    }
    return true;
  }
}
