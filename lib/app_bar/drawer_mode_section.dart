import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/theme/theme_manager.dart';

class DrawerModeSection extends StatelessWidget {
  const DrawerModeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return ExpansionTile(
          title: Text(
            'appearance'.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Gelasio',
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: Text('dark_mode'.tr()),
              trailing: Switch(
                value: currentMode == ThemeMode.dark,
                onChanged: (isDarkMode) {
                  themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}