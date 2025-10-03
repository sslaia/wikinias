import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';
import 'package:wikinias/niaspedia/widgets/niaspedia_shortcuts.dart';

import '../../widgets/home_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import '../../app_bar/special_pages_text.dart';
import '../niaspedia_special_pages_screen.dart';

class NiaspediaSpecialPagesBottomAppBar extends StatelessWidget {
  const NiaspediaSpecialPagesBottomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {

    return BottomAppBar(
        child: Row(
          children: [
            SpecialPagesText(color: npColor),
            const Spacer(),
            HomeIconButton(color: npColor, route: npRoute),
            RefreshIconButton(color: npColor, destination: NiaspediaSpecialPagesScreen(title: title)),
            ShortcutsIconButton(shortcuts: NiaspediaShortcuts(), color: npColor),
          ],
        ),
    );
  }
}
