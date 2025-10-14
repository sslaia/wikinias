import 'package:flutter/material.dart';

import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../app_bar/open_drawer_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_home_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import '../wikikamus_page_screen.dart';

class WikikamusBottomAppBar extends StatefulWidget {
  const WikikamusBottomAppBar({super.key});

  @override
  State<WikikamusBottomAppBar> createState() => _WikikamusBottomAppBarState();
}

class _WikikamusBottomAppBarState extends State<WikikamusBottomAppBar> {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToNewPage(String pageTitle) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => WikikamusPageScreen(title: pageTitle),
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
          BottomAppBarTextButton(label: 'wikikamus'),
          const Spacer(),
          RefreshHomeIconButton(color: color, route: '/wikikamus'),
          ShortcutsIconButton(),
          RandomIconButton(
            project: 'wikikamus',
            color: color,
            onRandomTitleFound: _navigateToNewPage,
          ),
        ],
      ),
    );
  }
}
