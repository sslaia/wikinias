import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../niaspedia_home_screen.dart';
import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../app_bar/open_drawer_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_home_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import 'niaspedia_shortcuts.dart';

class NiaspediaBottomAppBar extends StatelessWidget {
  const NiaspediaBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          OpenDrawerButton(project: npProject, color: npColor),
          BottomAppBarTextButton(label: npProject, color: npColor, destination: NiaspediaHomeScreen()),
          const Spacer(),
          RefreshHomeIconButton(color: npColor, route: npRoute),
          ShortcutsIconButton(shortcuts: NiaspediaShortcuts(), color: npColor),
          RandomIconButton(project: npProject, color: npColor),
        ],
      ),
    );
  }
}
