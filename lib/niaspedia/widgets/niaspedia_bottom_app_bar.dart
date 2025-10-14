import 'package:flutter/material.dart';

import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../app_bar/open_drawer_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_home_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import '../niaspedia_page_screen.dart';

class NiaspediaBottomAppBar extends StatefulWidget {
  const NiaspediaBottomAppBar({super.key});

  @override
  State<NiaspediaBottomAppBar> createState() => _NiaspediaBottomAppBarState();
}

class _NiaspediaBottomAppBarState extends State<NiaspediaBottomAppBar> {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToNewPage(String pageTitle) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => NiaspediaPageScreen(title: pageTitle),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return BottomAppBar(
      child: Row(
        children: [
          OpenDrawerButton(),
          BottomAppBarTextButton(label: 'niaspedia'),
          const Spacer(),
          RefreshHomeIconButton(color: color, route: '/'),
          ShortcutsIconButton(),
          RandomIconButton(
            project: 'niaspedia',
            color: color,
            onRandomTitleFound: _navigateToNewPage,
          ),
        ],
      ),
    );
  }
}
