import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/font_size_provider.dart';
import '../screens/settings_screen.dart';

class DrawerSettingsSection extends StatelessWidget {
  const DrawerSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return ExpansionTile(
          title: Text(
            'settings',
            style: TextStyle(
              fontFamily: 'Gelasio',
              color: Theme.of(context).colorScheme.primary,
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
          children: [
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(
                'update_service',
                style: TextStyle(fontSize: baseFontSize),
              ).tr(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
