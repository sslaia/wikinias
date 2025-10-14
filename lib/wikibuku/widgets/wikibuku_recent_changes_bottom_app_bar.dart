import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_bar/refresh_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import '../../app_bar/special_pages_text.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/home_icon_button.dart';
import '../wikibuku_recent_changes_screen.dart';

class WikibukuRecentChangesBottomAppBar extends StatelessWidget {
  const WikibukuRecentChangesBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return BottomAppBar(
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => Row(
          children: [
            SpecialPagesText(color: color),
            const Spacer(),
            HomeIconButton(color: color, route: settingsProvider.getProjectRoute()),
            RefreshIconButton(
              color: color,
              destination: WikibukuRecentChangesScreen(),
            ),
            ShortcutsIconButton(),
          ],
        ),
      ),
    );
  }
}
