import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/font_size_provider.dart';
import '../providers/settings_provider.dart';

class DrawerProjectSelectionSection extends StatelessWidget {
  const DrawerProjectSelectionSection({super.key, required this.project});

  final String project;

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) => ExpansionTile(
            initiallyExpanded: false,
            title: Text(
              'projects',
              style: TextStyle(
                fontFamily: 'Gelasio',
                color: Theme.of(context).colorScheme.primary,
                fontSize: baseFontSize,
                fontWeight: FontWeight.w700,
              ),
            ).tr(),
            children: [
              ListTile(
                leading: Icon(
                  Icons.language_outlined,
                  color: Color(0xff121298),
                ),
                title: Text(
                  'Niaspedia',
                  style: TextStyle(fontSize: baseFontSize),
                ),
                trailing: (project == 'Niaspedia') ? Icon(Icons.done) : null,
                onTap: () {
                  settingsProvider.selectedProject = Project.Niaspedia;
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.translate_outlined,
                  color: Colors.deepOrange,
                ),
                title: Text(
                  'Wikikamus',
                  style: TextStyle(fontSize: baseFontSize),
                ),
                trailing: (project == 'Wikikamus') ? Icon(Icons.done) : null,
                onTap: () {
                  settingsProvider.selectedProject = Project.Wikikamus;
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wikikamus');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.menu_book_outlined,
                  color: Color(0xff9b00a1),
                ),
                title: Text(
                  'Wikibuku',
                  style: TextStyle(fontSize: baseFontSize),
                ),
                trailing: (project == 'Wikibuku') ? Icon(Icons.done) : null,
                onTap: () {
                  settingsProvider.selectedProject = Project.Wikibuku;
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wikibuku');
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined, color: Color(0xff121298)),
                title: Text(
                  'courses',
                  style: TextStyle(fontSize: baseFontSize),
                ).tr(),
                trailing: (project == 'Courses') ? Icon(Icons.done) : null,
                onTap: () {
                  settingsProvider.selectedProject = Project.Courses;
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/courses');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: Color(0xff9b00a1),
                ),
                title: Text(
                  'gallery',
                  style: TextStyle(fontSize: baseFontSize),
                ).tr(),
                trailing: (project == 'Gallery') ? Icon(Icons.done) : null,
                onTap: () {
                  settingsProvider.selectedProject = Project.Gallery;
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/gallery');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
