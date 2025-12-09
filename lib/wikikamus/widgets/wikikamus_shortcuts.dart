import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:wikinias/wikikamus/wikikamus_page_screen.dart';
import 'package:wikinias/wikikamus/wikikamus_recent_changes_screen.dart';
import 'package:wikinias/app_bar/shortcuts_kb_text_button.dart';
import 'package:wikinias/app_bar/shortcuts_rc_text_button.dart';
import 'package:wikinias/app_bar/shortcuts_special_text_button.dart';

class WikikamusShortcuts extends StatelessWidget {
  const WikikamusShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final Color altColor = Theme.of(context).colorScheme.secondary;

    return Container(
      width: double.infinity,
      height: 300.0,
      decoration: const BoxDecoration(
        // color: Color(0xfffaf6ed),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'shortcuts',
            style: TextStyle(fontSize: 14.0, color: color),
          ).tr(),
          const SizedBox(height: 20.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            children: [
              ShortcutsRcTextButton(color: color, rcScreen: WikikamusRecentChangesScreen()),
              ShortcutsSpecialTextButton(
                screen: WikikamusPageScreen(title: 'Wikikamus:Angombakhata'),
                text: 'announcement',
                color: altColor
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusPageScreen(title: 'Wikikamus:Bawagöli zato'),
                text: 'community_portal',
                color: color,
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusPageScreen(title: 'Wikikamus:Monganga afo'),
                text: 'village_pump',
                color: altColor,
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusPageScreen(title: 'Wikikamus:Nahia wamakori'),
                text: 'sandbox',
                color: color,
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusPageScreen(title: 'Fanolo:Fanolo'),
                text: 'help',
                color: altColor,
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusPageScreen(title: 'Wikikamus:Sangai halöŵö'),
                text: 'helpers',
                color: color,
              ),
              ShortcutsKbTextButton(color: altColor),
            ],
          ),
        ],
      ),
    );
  }
}
