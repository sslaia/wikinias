import 'package:flutter/material.dart';

import 'package:wikinias/app_bar/random_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../app_bar/open_drawer_button.dart';
import '../../app_bar/refresh_home_icon_button.dart';
import '../wikibuku_page_screen.dart';

class WikibukuBottomAppBar extends StatefulWidget {
  const WikibukuBottomAppBar({super.key});

  @override
  State<WikibukuBottomAppBar> createState() => _WikibukuBottomAppBarState();
}

class _WikibukuBottomAppBarState extends State<WikibukuBottomAppBar> {

  @override
  void initState() {
    super.initState();
  }

  void _navigateToNewPage(String pageTitle) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => WikibukuPageScreen(title: pageTitle),
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
          BottomAppBarTextButton(label: 'wikibuku'),
          const Spacer(),
          RefreshHomeIconButton(color: color, route: '/wikibuku'),
          ShortcutsIconButton(),
          RandomIconButton(
            project: 'wikibuku',
            color: color,
            onRandomTitleFound: _navigateToNewPage,
          ),
        ],
      ),
    );
  }
}
