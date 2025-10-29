import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikinias/courses/courses_screen.dart';
import 'package:wikinias/gallery/gallery_screen.dart';
import 'package:wikinias/niaspedia/niaspedia_home_screen.dart';
import 'package:wikinias/niaspedia/widgets/niaspedia_drawer_section.dart';
import 'package:wikinias/niaspedia/widgets/niaspedia_footer.dart';
import 'package:wikinias/niaspedia/widgets/niaspedia_shortcuts.dart';
import 'package:wikinias/wikibuku/widgets/wikibuku_shortcuts.dart';
import 'package:wikinias/wikibuku/wikibuku_home_screen.dart';
import 'package:wikinias/wikikamus/widgets/wikikamus_drawer_section.dart';
import 'package:wikinias/wikikamus/widgets/wikikamus_shortcuts.dart';
import 'package:wikinias/wikikamus/wikikamus_home_screen.dart';

import '../courses/courses_drawer_section.dart';
import '../gallery/gallery_drawer_section.dart';
import '../wikibuku/widgets/wikibuku_drawer_section.dart';
import '../wikibuku/widgets/wikibuku_footer.dart';
import '../wikikamus/widgets/wikikamus_footer.dart';

enum Project { Niaspedia, Wikikamus, Wikibuku, Courses, Gallery }

enum Language { English, Nias }

enum FontSize { Small, Normal, Large, ExtraLarge }

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _projectKey = 'selectedProject';

  Project _selectedProject = Project.Niaspedia;
  Language _selectedLanguage = Language.Nias;
  FontSize _selectedFontSize = FontSize.Normal;

  SettingsProvider(this._prefs) {
    _loadSelectedProject();
  }

  Project get selectedProject => _selectedProject;
  Language get selectedLanguage => _selectedLanguage;
  FontSize get selectedFontSize => _selectedFontSize;

  void _loadSelectedProject() {
    final savedProjectName = _prefs.getString(_projectKey);
    if (savedProjectName != null) {
      try {
        _selectedProject = Project.values.firstWhere(
            (project) => project.name == savedProjectName
        );
      } catch (e) {
        _selectedProject = Project.Niaspedia;
      }
    }
  }

  Future<void> _saveSelectedProject() async {
    await _prefs.setString(_projectKey, _selectedProject.name);
  }

  set selectedProject(Project project) {
    if (_selectedProject != project) {
      _selectedProject = project;
      notifyListeners();
      _saveSelectedProject();
    }
  }

  set selectedLanguage(Language language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  set selectedFontSize(FontSize fontSize) {
    _selectedFontSize = fontSize;
    notifyListeners();
  }

  String getProjectName() {
    switch (_selectedProject) {
      case Project.Gallery:
        return 'Gallery';
      case Project.Courses:
        return 'Courses';
      case Project.Wikibuku:
        return 'Wikibuku';
      case Project.Wikikamus:
        return 'Wikikamus';
      default:
        return 'Niaspedia';
    }
  }

  Color getProjectColor() {
    switch (_selectedProject) {
      case Project.Gallery:
        return Color(0xff9b00a1);
      case Project.Courses:
        return Color(0xff1b1919);
      case Project.Wikibuku:
        return Color(0xff9b00a1);
      case Project.Wikikamus:
        return Colors.deepOrange;
      default:
        return Color(0xff121298);
    }
  }

  String getLanguage() {
    switch (_selectedLanguage) {
      case Language.English:
        return 'en';
      default:
        return 'id';
    }
  }

  String getProjectUrl() {
    switch (_selectedProject) {
      case Project.Gallery:
        return 'https://nia.m.wikipedia.org/';
      case Project.Courses:
        return 'https://nia.m.wikipedia.org/';
      case Project.Wikibuku:
        return 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
      case Project.Wikikamus:
        return 'https://nia.m.wiktionary.org/wiki/';
      default:
        return 'https://nia.m.wikipedia.org/wiki/';
    }
  }

  String getProjectApiUrl() {
    switch (_selectedProject) {
      case Project.Gallery:
        return 'https://nia.wikipedia.org/w/api.php';
      case Project.Courses:
        return 'https://nia.wikipedia.org/w/api.php';
      case Project.Wikibuku:
        return 'https://incubator.wikimedia.org/w/api.php';
      case Project.Wikikamus:
        return 'https://nia.wiktionary.org/w/api.php';
      default:
        return 'https://nia.wikipedia.org/w/api.php';
    }
  }

  String getProjectRoute() {
    switch (_selectedProject) {
      case Project.Gallery:
        return '/gallery';
      case Project.Courses:
        return '/courses';
      case Project.Wikibuku:
        return '/wikibuku';
      case Project.Wikikamus:
        return '/wikikamus';
      default:
        return '/';
    }
  }

  Widget getProjectHome() {
    switch (_selectedProject) {
      case Project.Gallery:
        return GalleryScreen();
      case Project.Courses:
        return CoursesScreen();
      case Project.Wikibuku:
        return WikibukuHomeScreen();
      case Project.Wikikamus:
        return WikikamusHomeScreen();
      default:
        return NiaspediaHomeScreen();
    }
  }

  Widget getProjectDrawerSection() {
    switch (_selectedProject) {
      case Project.Gallery:
        return GalleryDrawerSection();
      case Project.Courses:
        return CoursesDrawerSection();
      case Project.Wikibuku:
        return WikibukuDrawerSection();
      case Project.Wikikamus:
        return WikikamusDrawerSection();
      default:
        return NiaspediaDrawerSection();
    }
  }


  Widget getProjectShortcuts() {
    switch (_selectedProject) {
      case Project.Gallery:
        return NiaspediaShortcuts();
      case Project.Courses:
        return NiaspediaShortcuts();
      case Project.Wikibuku:
        return WikibukuShortcuts();
      case Project.Wikikamus:
        return WikikamusShortcuts();
      default:
        return NiaspediaShortcuts();
    }
  }

  String getProjectFooter() {
    switch (_selectedProject) {
      case Project.Gallery:
        return niaspediaFooter;
      case Project.Courses:
        return niaspediaFooter;
      case Project.Wikibuku:
        return wikibukuFooter;
      case Project.Wikikamus:
        return wikikamusFooter;
      default:
        return niaspediaFooter;
    }
  }

  String getProjectMainImage() {
    switch (_selectedProject) {
      case Project.Gallery:
        return "assets/images/ni'otalingawöliwöli.webp";
      case Project.Courses:
        return "assets/images/ni'owulurai.webp";
      case Project.Wikibuku:
        return "assets/images/figa.webp";
      case Project.Wikikamus:
        return "assets/images/baluse.webp";
      default:
        return "assets/images/tolögu.webp";
    }
  }

  String getProjectPageImage() {
    switch (_selectedProject) {
      case Project.Gallery:
        return "assets/images/bowogafasi.webp";
      case Project.Courses:
        return "assets/images/bowogafasi.webp";
      case Project.Wikibuku:
        return "assets/images/bowogafasi.webp";
      case Project.Wikikamus:
        return "assets/images/ni'obutelai.webp";
      default:
        return "assets/images/ni'ogazi.webp";
    }
  }

  String getProjectSpecialPagesImage() {
    switch (_selectedProject) {
      case Project.Gallery:
        return "assets/images/ornament2.webp";
      case Project.Courses:
        return "assets/images/ornament2.webp";
      case Project.Wikibuku:
        return "assets/images/ornament2.webp";
      case Project.Wikikamus:
        return "assets/images/ornament3.webp";
      default:
        return "assets/images/ornament1.webp";
    }
  }

  String getAmaedolaImage() {
    return "assets/images/amaedola.webp";
  }

  String getBibleImage() {
    return "assets/images/amaedola.webp";
  }
  String getHohoImage() {
    return "assets/images/amaedola.webp";
  }
  String getSongsImage() {
    return "assets/images/amaedola.webp";
  }

  String getStoriesImage() {
    return "assets/images/amaedola.webp";
  }

  String getSundermannImage() {
    return "assets/images/amaedola.webp";
  }
}
