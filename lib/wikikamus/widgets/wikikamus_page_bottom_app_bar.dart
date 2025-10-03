import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../wikikamus_page_screen.dart';

class WikikamusPageBottomAppBar extends StatelessWidget {
  final String title;
  const WikikamusPageBottomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          BottomAppBarTextButton(label: wkProject, color: wkColor, destination: WikikamusPageScreen(title: title),),
          const Spacer(),
          HomeIconButton(color: wkColor, route: wkRoute),
          RefreshIconButton(color: wkColor, destination: WikikamusPageScreen(title: title)),
          RandomIconButton(project: wkProject, color: wkColor),
        ],
      ),
    );
  }
}
