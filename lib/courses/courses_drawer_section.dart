import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/font_size_provider.dart';
import 'courses_screen.dart';
import '../app_bar/drawer_list_item.dart';

class CoursesDrawerSection extends StatelessWidget {
  const CoursesDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return ExpansionTile(
          initiallyExpanded: true,
          title: Text('courses', style: TextStyle(
            fontFamily: 'Gelasio',
            color: Theme.of(context).colorScheme.primary,
            fontSize: baseFontSize,
            fontWeight: FontWeight.bold,
          )).tr(),
          children: [
            DrawerListItem(
              text: 'courses_songs',
              icon: Icon(Icons.school_outlined),
              destination: CoursesScreen(),
            ),
            DrawerListItem(
              text: 'courses_youtube',
              icon: Icon(Icons.school_outlined),
              destination: CoursesScreen(),
            ),
            DrawerListItem(
              text: 'courses_proverbs',
              icon: Icon(Icons.school_outlined),
              destination: CoursesScreen(),
            ),
            DrawerListItem(
              text: 'courses_stories',
              icon: Icon(Icons.school_outlined),
              destination: CoursesScreen(),
            ),
          ],
        );
      },
    );
  }
}
