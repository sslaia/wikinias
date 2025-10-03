import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../../app_bar/shortcuts_icon_button.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../../app_bar/special_pages_text.dart';
import '../niaspedia_recent_changes_screen.dart';
import 'niaspedia_shortcuts.dart';

class NiaspediaRecentChangesBottomAppBar extends StatelessWidget {
  const NiaspediaRecentChangesBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          SpecialPagesText(color: npColor),
          const Spacer(),
          HomeIconButton(color: npColor, route: npRoute),
          RefreshIconButton(color: npColor, destination: NiaspediaRecentChangesScreen()),
          ShortcutsIconButton(color: npColor, shortcuts: NiaspediaShortcuts()),
        ],
      ),
    );
  }
}