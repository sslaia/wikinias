import 'package:flutter/material.dart';

import '../../widgets/featured_section_title.dart';
import '../../widgets/portal_text_button.dart';
import '../bible/bible_screen.dart';
import '../songs/songs_screen.dart';
import '../stories/stories_screen.dart';
import '../amaedola/amaedola_screen.dart';
import '../hoho/hoho_screen.dart';
import '../sundermann/sundermann_screen.dart';

class WikibukuPortal extends StatelessWidget {
  const WikibukuPortal({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FeaturedSectionTitle(
          label: 'portals',
          color: color,
        ),
        const SizedBox(height: 28.0),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              PortalTextButton(label: 'wikibuku_amaedola', color: color, destination: AmaedolaScreen()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'wikibuku_hoho', color: color, destination: HohoScreen()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'wikibuku_stories', color: color, destination: StoriesScreen()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'wikibuku_bible', color: color, destination: BibleScreen()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'wikibuku_songs', color: color, destination: SongsScreen()),
              const SizedBox(width: 8),
              PortalTextButton(label: 'wikibuku_sundermann', color: color, destination: SundermannScreen()),
            ],
          ),
        ),
      ],
    );
  }
}
