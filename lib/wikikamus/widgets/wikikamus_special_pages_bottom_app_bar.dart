import 'package:flutter/material.dart';

import '../../widgets/home_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import '../../app_bar/special_pages_text.dart';
import '../wikikamus_special_pages_screen.dart';

class WikikamusSpecialPagesBottomAppBar extends StatelessWidget {
  const WikikamusSpecialPagesBottomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return BottomAppBar(
      child: Row(
        children: [
          SpecialPagesText(color: color),
          const Spacer(),
          HomeIconButton(color: color, route: '/wikikamus'),
          RefreshIconButton(color: color, destination: WikikamusSpecialPagesScreen(title: title)),
          ShortcutsIconButton(),
        ],
      ),
    );
  }
}
