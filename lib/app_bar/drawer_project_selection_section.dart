import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/font_size_provider.dart';
import '../providers/settings_provider.dart';

class DrawerProjectSelectionSection extends StatelessWidget {
  const DrawerProjectSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) => ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'projects'.tr(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Gelasio',
                fontWeight: FontWeight.w700,
              ),
            ),
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
                trailing: ( settingsProvider.getProjectName() == 'Niaspedia') ? Icon(Icons.done) : null,
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
                trailing: ( settingsProvider.getProjectName() == 'Wikikamus') ? Icon(Icons.done) : null,
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
                trailing: ( settingsProvider.getProjectName() == 'Wikibuku') ? Icon(Icons.done) : null,
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
                trailing: ( settingsProvider.getProjectName() == 'Courses') ? Icon(Icons.done) : null,
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
                trailing: ( settingsProvider.getProjectName() == 'Gallery') ? Icon(Icons.done) : null,
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
