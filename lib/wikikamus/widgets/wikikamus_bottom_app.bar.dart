import 'package:flutter/material.dart';
import 'package:wikinias/app_bar/bottom_app_bar_text_button.dart';
import 'package:wikinias/constants.dart';

import '../../app_bar/open_drawer_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_home_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import '../wikikamus_home_screen.dart';
import 'wikikamus_shortcuts.dart';

class WikikamusBottomAppBar extends StatelessWidget {
  const WikikamusBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          OpenDrawerButton(project: wkProject, color: wkColor),
          BottomAppBarTextButton(label: wkProject, color: wkColor, destination: WikikamusHomeScreen(),),
          const Spacer(),
          RefreshHomeIconButton(color: wkColor, route: wkRoute),
          ShortcutsIconButton(shortcuts: WikikamusShortcuts(), color: wkColor),
          RandomIconButton(project: wkProject, color: wkColor),
        ],
      ),
    );
  }
}
