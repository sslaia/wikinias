import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../../app_bar/shortcuts_icon_button.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../../app_bar/special_pages_text.dart';
import '../wikikamus_recent_changes_screen.dart';
import 'wikikamus_shortcuts.dart';

class WikikamusRecentChangesBottomAppBar extends StatelessWidget {
  const WikikamusRecentChangesBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          SpecialPagesText(color: wkColor),
          const Spacer(),
          HomeIconButton(color: wkColor, route: wkRoute),
          RefreshIconButton(color: wkColor, destination: WikikamusRecentChangesScreen()),
          ShortcutsIconButton(color: wkColor, shortcuts: WikikamusShortcuts(),),
        ],
      ),
    );
  }
}
