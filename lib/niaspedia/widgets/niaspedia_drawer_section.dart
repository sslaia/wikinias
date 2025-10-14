import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_bar/drawer_list_item.dart';
import '../../providers/font_size_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/create_new_page_form.dart';

class NiaspediaDrawerSection extends StatelessWidget {
  const NiaspediaDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            'Niaspedia',
            style: TextStyle(
              fontFamily: 'Gelasio',
              color: color,
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
          children: [
            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) => DrawerListItem(
                text: 'create_new_page',
                icon: Icon(Icons.create_outlined),
                destination: CreateNewPageForm(url: settingsProvider.getProjectUrl()),
              ),
            ),
          ],
        );
      },
    );
  }
}
