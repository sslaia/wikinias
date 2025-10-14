import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class ShortcutsIconButton extends StatelessWidget {
  const ShortcutsIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => IconButton(
      tooltip: 'shortcuts'.tr(),
      icon: Icon(Icons.switch_access_shortcut_outlined),
      color: color,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return settingsProvider.getProjectShortcuts();
          },
        );
      },
    ),);
  }
}
