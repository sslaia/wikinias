import 'package:flutter/material.dart';

import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../niaspedia_page_screen.dart';
import '../../constants.dart';

class NiaspediaPageBottomAppBar extends StatelessWidget {
  final String title;
  const NiaspediaPageBottomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          BottomAppBarTextButton(label: npProject, color: npColor, destination: NiaspediaPageScreen(title: title),),
          const Spacer(),
          HomeIconButton(color: npColor, route: npRoute),
          RefreshIconButton(color: npColor, destination: NiaspediaPageScreen(title: title)),
          RandomIconButton(project: npProject, color: npColor),
        ],
      ),
    );
  }
}
