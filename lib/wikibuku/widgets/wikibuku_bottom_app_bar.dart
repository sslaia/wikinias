import 'package:flutter/material.dart';
import 'package:wikinias/app_bar/random_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/constants.dart';
import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../app_bar/open_drawer_button.dart';
import '../../app_bar/refresh_home_icon_button.dart';
import '../wikibuku_home_screen.dart';
import 'wikibuku_shortcuts.dart';

class WikibukuBottomAppBar extends StatelessWidget {
  const WikibukuBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          OpenDrawerButton(project: wbProject, color: wbColor),
          BottomAppBarTextButton(label: wbProject, color: wbColor, destination: WikibukuHomeScreen()),
          const Spacer(),
          RefreshHomeIconButton(color: wbColor, route: wbRoute),
          ShortcutsIconButton(shortcuts: WikibukuShortcuts(), color: wbColor),
          RandomIconButton(project: wbProject, color: wbColor)
        ],
      ),
    );
  }
}
