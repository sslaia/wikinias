import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../../app_bar/refresh_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import '../../app_bar/special_pages_text.dart';
import '../../widgets/home_icon_button.dart';
import '../wikibuku_recent_changes_screen.dart';
import 'wikibuku_shortcuts.dart';

class WikibukuRecentChangesBottomAppBar extends StatelessWidget {
  const WikibukuRecentChangesBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          SpecialPagesText(color: wbColor),
          const Spacer(),
          HomeIconButton(color: wbColor, route: wbRoute),
          RefreshIconButton(color: wbColor, destination: WikibukuRecentChangesScreen()),
          ShortcutsIconButton(color: wbColor, shortcuts: WikibukuShortcuts()),
        ],
      ),
    );
  }
}