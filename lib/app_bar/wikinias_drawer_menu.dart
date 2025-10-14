import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import 'drawer_about_section.dart';
import 'drawer_font_selection_section.dart';
import 'drawer_header_container.dart';
import 'drawer_language_selection_section.dart';
import 'drawer_project_selection_section.dart';

class WikiniasDrawerMenu extends StatelessWidget {
  const WikiniasDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeaderContainer(image: settingsProvider.getProjectMainImage()),
          settingsProvider.getProjectDrawerSection(),
          DrawerProjectSelectionSection(project: settingsProvider.getProjectName()),
          DrawerLanguageSelectionSection(),
          DrawerFontSelectionSection(),
          DrawerAboutSection(),
        ],
      ),),
    );
  }
}
