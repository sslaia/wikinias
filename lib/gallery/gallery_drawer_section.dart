import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_bar/drawer_list_item.dart';
import '../providers/font_size_provider.dart';
import 'gallery_screen.dart';

class GalleryDrawerSection extends StatelessWidget {
  const GalleryDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            'gallery',
            style: TextStyle(
              fontFamily: 'Gelasio',
              color: Theme.of(context).colorScheme.primary,
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
          children: [
            DrawerListItem(
              text: 'gallery_dances',
              icon: Icon(Icons.photo_library_outlined),
              destination: GalleryScreen(),
            ),
            DrawerListItem(
              text: 'gallery_arts',
              icon: Icon(Icons.photo_library_outlined),
              destination: GalleryScreen(),
            ),
            DrawerListItem(
              text: 'gallery_building',
              icon: Icon(Icons.photo_library_outlined),
              destination: GalleryScreen(),
            ),
            DrawerListItem(
              text: 'gallery_others',
              icon: Icon(Icons.photo_library_outlined),
              destination: GalleryScreen(),
            ),
          ],
        );
      },
    );
  }
}
