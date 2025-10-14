import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/app_bar/drawer_list_item.dart';
import '../../providers/font_size_provider.dart';
import '../amaedola/amaedola_screen.dart';
import '../bible/bible_screen.dart';
import '../hoho/hoho_screen.dart';
import '../songs/songs_screen.dart';
import '../stories/stories_screen.dart';
import '../sundermann/sundermann_screen.dart';

class WikibukuDrawerSection extends StatelessWidget {
  const WikibukuDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            'wikibuku',
            style: TextStyle(
              fontFamily: 'Gelasio',
              color: color,
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
          children: [
            DrawerListItem(
              text: 'wikibuku_hoho',
              icon: Icon(Icons.auto_stories_outlined),
              destination: HohoScreen(),
            ),
            DrawerListItem(
              text: 'wikibuku_songs',
              icon: Icon(Icons.auto_stories_outlined),
              destination: SongsScreen(),
            ),
            DrawerListItem(
              text: 'wikibuku_amaedola',
              icon: Icon(Icons.auto_stories_outlined),
              destination: AmaedolaScreen(),
            ),
            DrawerListItem(
              text: 'wikibuku_stories',
              icon: Icon(Icons.auto_stories_outlined),
              destination: StoriesScreen(),
            ),
            DrawerListItem(
              text: 'wikibuku_bible',
              icon: Icon(Icons.auto_stories_outlined),
              destination: BibleScreen(),
            ),
            DrawerListItem(
              text: 'wikibuku_sundermann',
              icon: Icon(Icons.auto_stories_outlined),
              destination: SundermannScreen(),
            ),
          ],
        );
      },
    );
  }
}
