import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_bar/shortcuts_icon_button.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../../app_bar/special_pages_text.dart';
import '../wikikamus_recent_changes_screen.dart';

class WikikamusRecentChangesBottomAppBar extends StatelessWidget {
  const WikikamusRecentChangesBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    return BottomAppBar(
      child: Row(
        children: [
          SpecialPagesText(color: color),
          const Spacer(),
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) => HomeIconButton(
              color: color,
              route: settingsProvider.getProjectRoute(),
            ),
          ),
          RefreshIconButton(
            color: color,
            destination: WikikamusRecentChangesScreen(),
          ),
          ShortcutsIconButton(),
        ],
      ),
    );
  }
}
