import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_bar/drawer_list_item.dart';
import '../../providers/font_size_provider.dart';
import '../guides/create_new_entry.dart';

class WikikamusDrawerSection extends StatelessWidget {
  const WikikamusDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            'wikikamus',
            style: TextStyle(
              fontFamily: 'Gelasio',
              color: color,
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
          children: [
            DrawerListItem(
              text: 'create_new_entry',
              icon: Icon(Icons.create_outlined),
              destination: CreateNewEntry(),
            ),
          ],
        );
      },
    );
  }
}
