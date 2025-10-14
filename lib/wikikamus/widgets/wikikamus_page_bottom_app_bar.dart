import 'package:flutter/material.dart';

import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../wikikamus_page_screen.dart';

class WikikamusPageBottomAppBar extends StatefulWidget {
  final String title;
  const WikikamusPageBottomAppBar({super.key, required this.title});

  @override
  State<WikikamusPageBottomAppBar> createState() =>
      _WikikamusPageBottomAppBarState();
}

class _WikikamusPageBottomAppBarState extends State<WikikamusPageBottomAppBar> {
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
          BottomAppBarTextButton(label: 'wikikamus'),
          const Spacer(),
          HomeIconButton(color: color, route: '/wikikamus'),
          RefreshIconButton(
            color: color,
            destination: WikikamusPageScreen(title: widget.title),
          ),
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
