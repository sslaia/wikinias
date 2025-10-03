import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../../app_bar/bottom_app_bar_text_button.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/random_icon_button.dart';
import '../../app_bar/refresh_icon_button.dart';
import '../wikibuku_page_screen.dart';

class WikibukuPageBottomAppBar extends StatelessWidget {
  final String title;
  const WikibukuPageBottomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
        BottomAppBarTextButton(label: wbProject, color: wbColor, destination: WikibukuPageScreen(title: title)),
        const Spacer(),
        HomeIconButton(color: wbColor, route: wbRoute),
        RefreshIconButton(color: wbColor, destination: WikibukuPageScreen(title: title)),
        RandomIconButton(project: wbProject, color: wbColor),
        ],
      ),
    );
  }
}
