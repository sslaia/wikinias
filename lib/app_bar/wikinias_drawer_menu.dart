import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';
import 'drawer_header_container.dart';
import 'drawer_list_item.dart';
import 'drawer_project_selection_section.dart';

class WikiniasDrawerMenu extends StatelessWidget {
  final String project;
  final String image;
  final Color color;
  final Widget projectDrawerSection;

  const WikiniasDrawerMenu({
    super.key,
    required this.project,
    required this.image,
    required this.color,
    required this.projectDrawerSection
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeaderContainer(image: image, color: color),
          projectDrawerSection,
          DrawerProjectSelectionSection(project: project),
          Divider(),
          DrawerListItem(
            text: 'settings',
            icon: Icon(Icons.settings_outlined),
            destination: SettingsScreen(),
          ),
        ],
      ),
    );
  }
}
