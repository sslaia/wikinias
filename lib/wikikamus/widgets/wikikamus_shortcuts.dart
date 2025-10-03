import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app_bar/shortcuts_kb_text_button.dart';
import '../../app_bar/shortcuts_rc_text_button.dart';
import '../../app_bar/shortcuts_special_text_button.dart';
import '../wikikamus_special_pages_screen.dart';
import '../wikikamus_recent_changes_screen.dart';

class WikikamusShortcuts extends StatelessWidget {
  const WikikamusShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Color(0xff121298);

    return Container(
      width: double.infinity,
      height: 300.0,
      decoration: const BoxDecoration(
        color: Color(0xfffaf6ed),
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
            style: TextStyle(fontSize: 14.0, color: Colors.black54),
          ).tr(),
          const SizedBox(height: 20.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            children: [
              ShortcutsRcTextButton(color: color, rcScreen: WikikamusRecentChangesScreen()),
              ShortcutsSpecialTextButton(
                screen: WikikamusSpecialPagesScreen(title: 'Wiktionary:Angombakhata'),
                text: 'announcement',
                color: Color(0xff9b00a1)
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusSpecialPagesScreen(title: 'Wiktionary:Bawagöli zato'),
                text: 'community_portal',
                color: color,
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusSpecialPagesScreen(title: 'Wiktionary:Monganga afo'),
                text: 'village_pump',
                color: Color(0xff9b00a1),
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusSpecialPagesScreen(title: 'Wiktionary:Nahia wamakori'),
                text: 'sandbox',
                color: color,
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusSpecialPagesScreen(title: 'Fanolo:Fanolo'),
                text: 'help',
                color: Color(0xff9b00a1),
              ),
              ShortcutsSpecialTextButton(
                screen: WikikamusSpecialPagesScreen(title: 'Wiktionary:Sangai halöŵö'),
                text: 'helpers',
                color: color,
              ),
              ShortcutsKbTextButton(color: Color(0xff9b00a1)),
            ],
          ),
        ],
      ),
    );
  }
}
