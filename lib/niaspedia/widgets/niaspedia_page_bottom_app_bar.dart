import 'package:flutter/material.dart';

import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../niaspedia_page_screen.dart';

class NiaspediaPageBottomAppBar extends StatefulWidget {
  final String title;
  const NiaspediaPageBottomAppBar({super.key, required this.title});

  @override
  State<NiaspediaPageBottomAppBar> createState() =>
      _NiaspediaPageBottomAppBarState();
}

class _NiaspediaPageBottomAppBarState extends State<NiaspediaPageBottomAppBar> {
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
          BottomAppBarTextButton(label: 'niaspedia'),
          const Spacer(),
          HomeIconButton(color: color, route: '/'),
          RefreshIconButton(
            color: color,
            destination: NiaspediaPageScreen(title: widget.title),
          ),
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
