import 'package:flutter/material.dart';

class HomePortals {
  static Map<String, Map<String, List<Map<String, dynamic>>>> getPortals(
    BuildContext context,
  ) {
    return {
      'en': {'wikipedia': [], 'wiktionary': [], 'wikibooks': []},
      'id': {'wikipedia': [], 'wiktionary': [], 'wikibooks': []},
      'nia': {
        'wikipedia': [
          {'label': 'portal_religion', 'title': 'Portal:Agama'},
          {'label': 'portal_biology', 'title': 'Portal:Biologi'},
          {'label': 'portal_government', 'title': 'Portal:Famatörö'},
          {'label': 'portal_geography', 'title': 'Portal:Geografi'},
          {'label': 'portal_culture', 'title': 'Portal:Hada'},
          {'label': 'portal_maths', 'title': 'Portal:Matematika'},
          {'label': 'portal_media', 'title': 'Portal:Media'},
          {'label': 'portal_science', 'title': 'Portal:Sains'},
          {'label': 'portal_history', 'title': 'Portal:Sejarah'},
          {'label': 'portal_technology', 'title': 'Portal:Teknologi'},
        ],
        'wiktionary': [
          {"label": "portal_religion", "title": "Kategori:Agama"},
          {"label": "portal_animals", "title": "Kategori:Aurifö"},
          {"label": "portal_business", "title": "Kategori:Bisnis"},
          {"label": "portal_german", "title": "Kategori:Deutsch"},
          {"label": "portal_english", "title": "Kategori:Inggris"},
          {"label": "portal_government", "title": "Kategori:Famatörö"},
          {"label": "portal_health", "title": "Kategori:Fökhö"},
          {"label": "portal_custom", "title": "Kategori:Hada"},
          {"label": "portal_indonesian", "title": "Kategori:Indonesia"},
          {"label": "portal_colours", "title": "Kategori:La'a-la'a"},
          {"label": "portal_anatomy", "title": "Kategori:Ndroto-ndroto mboto"},
          {"label": "portal_nias", "title": "Kategori:Nias"},
          {"label": "portal_arts", "title": "Kategori:Seni"},
          {"label": "portal_plants", "title": "Kategori:Sinumbua"},
          {"label": "portal_technology", "title": "Kategori:Teknologi"},
          {"label": "portal_transport", "title": "Kategori:Transpor"},
        ],
        'wikibooks': [
          {"label": "portal_proverbs", "title": "Wb/nia/Amaedola"},
          {"label": "portal_custom", "title": "Category:Wb/nia/Budaya"},
          {"label": "portal_short_stories", "title": "Category:Wb/nia/Cerpen"},
          {"label": "portal_recipes", "title": "Category:Wb/nia/Fondrino"},
          {
            "label": "portal_folksongs",
            "title": "Category:Wb/nia/Hendri-hendri",
          },
          {"label": "portal_speeches", "title": "Category:Wb/nia/Hoho"},
          {"label": "portal_dictionary", "title": "Wb/nia/Kamus Nias-Jerman"},
          {"label": "portal_dances", "title": "Category:Wb/nia/Maena"},
          {"label": "portal_stories", "title": "Category:Wb/nia/Manö-manö"},
          {
            "label": "portal_fairy_tales",
            "title": "Category:Wb/nia/Nidunö-dunö",
          },
          {"label": "portal_novel", "title": "Category:Wb/nia/Novela"},
          {
            "label": "portal_nias_pop",
            "title": "Category:Wb/nia/Sinunö Pop Nias",
          },
          {"label": "portal_bible", "title": "Wb/nia/Sura Ni'amoni'ö"},
          {"label": "portal_wikijunior", "title": "Wb/nia/Wikiyunior"},
        ],
      },
    };
  }
}
