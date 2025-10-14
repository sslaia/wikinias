import 'package:flutter/material.dart';

import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../wikibuku_page_screen.dart';

class WikibukuPageBottomAppBar extends StatefulWidget {
  final String title;
  const WikibukuPageBottomAppBar({super.key, required this.title});

  @override
  State<WikibukuPageBottomAppBar> createState() =>
      _WikibukuPageBottomAppBarState();
}

class _WikibukuPageBottomAppBarState extends State<WikibukuPageBottomAppBar> {
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
          BottomAppBarTextButton(label: 'wikibuku'),
          const Spacer(),
          HomeIconButton(color: color, route: '/wikibuku'),
          RefreshIconButton(
            color: color,
            destination: WikibukuPageScreen(title: widget.title),
          ),
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
