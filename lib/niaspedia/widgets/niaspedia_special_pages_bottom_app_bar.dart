import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
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
    final Color color = Theme.of(context).colorScheme.primary;

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => BottomAppBar(
        child: Row(
          children: [
            SpecialPagesText(color: color),
            const Spacer(),
            HomeIconButton(
              color: color,
              route: settingsProvider.getProjectRoute(),
            ),
            RefreshIconButton(
              color: color,
              destination: NiaspediaSpecialPagesScreen(title: title),
            ),
            ShortcutsIconButton(),
          ],
        ),
      ),
    );
  }
}
