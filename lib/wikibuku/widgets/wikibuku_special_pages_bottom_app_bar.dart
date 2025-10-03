import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../screens/nias_keyboard_screen.dart';
import '../../widgets/home_icon_button.dart';
import '../../app_bar/shortcuts_icon_button.dart';
import '../../app_bar/special_pages_text.dart';
import '../wikibuku_special_pages_screen.dart';
import 'wikibuku_shortcuts.dart';

class WikibukuSpecialPagesBottomAppBar extends StatelessWidget {
  const WikibukuSpecialPagesBottomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(0xff9b00a1);

    return BottomAppBar(
      child: Row(
        children: [
          SpecialPagesText(color: color),
          const Spacer(),
          HomeIconButton(color: color, route: '/wikibuku'),
          RefreshIconButton(color: color, title: title),
          ShortcutsIconButton(shortcuts: WikibukuShortcuts(), color: color),
        ],
      ),
    );
  }
}

class RefreshIconButton extends StatelessWidget {
  const RefreshIconButton({
    super.key,
    required this.color,
    required this.title,
  });

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'refresh'.tr(),
      color: color,
      icon: Icon(Icons.refresh_outlined),
      onPressed: () {
        Navigator.pop(context);
        if (title == 'Wikipedia:Fafa wanura Nias') {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => NiasKeyboardScreen(color: color),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => WikibukuSpecialPagesScreen(title: title),
            ),
          );
        }
      },
    );
  }
}
