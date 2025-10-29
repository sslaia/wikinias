import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/font_size_provider.dart';
import '../providers/settings_provider.dart';

class DrawerFontSelectionSection extends StatelessWidget {
  const DrawerFontSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;

        return Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                'font_size'.tr(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Gelasio',
                  fontWeight: FontWeight.w700,
                ),
              ),
              children: [
                ListTile(
                  leading: Icon(Icons.text_decrease_outlined),
                  title: Text(
                    'small',
                    style: TextStyle(fontSize: baseFontSize * 0.8),
                  ).tr(),
                  trailing:
                      (fontSizeProvider.currentScale ==
                          FontSizeProvider.fontScales['small'])
                      ? Icon(Icons.done)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    fontSizeProvider.setFontSize('small');
                    settingsProvider.selectedFontSize = FontSize.Small;
                  },
                ),
                ListTile(
                  leading: Icon(Icons.text_format_outlined),
                  title: Text(
                    'normal',
                    style: TextStyle(fontSize: baseFontSize),
                  ).tr(),
                  trailing:
                      (fontSizeProvider.currentScale ==
                          FontSizeProvider.fontScales['normal'])
                      ? Icon(Icons.done)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    fontSizeProvider.setFontSize('normal');
                    settingsProvider.selectedFontSize = FontSize.Normal;
                  },
                ),
                ListTile(
                  leading: Icon(Icons.text_increase_outlined),
                  title: Text(
                    'large',
                    style: TextStyle(fontSize: baseFontSize * 1.2),
                  ).tr(),
                  trailing:
                      (fontSizeProvider.currentScale ==
                          FontSizeProvider.fontScales['large'])
                      ? Icon(Icons.done)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    fontSizeProvider.setFontSize('large');
                    settingsProvider.selectedFontSize = FontSize.Large;
                  },
                ),
                ListTile(
                  leading: Icon(Icons.text_increase_outlined),
                  title: Text(
                    'extra_large',
                    style: TextStyle(fontSize: baseFontSize * 1.4),
                  ).tr(),
                  trailing:
                      (fontSizeProvider.currentScale ==
                          FontSizeProvider.fontScales['extra_large'])
                      ? Icon(Icons.done)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    fontSizeProvider.setFontSize('extra_large');
                    settingsProvider.selectedFontSize = FontSize.ExtraLarge;
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
