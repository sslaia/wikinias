import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app_bar/shortcuts_kb_text_button.dart';
import '../../app_bar/shortcuts_rc_text_button.dart';
import '../../app_bar/shortcuts_special_text_button.dart';
import '../niaspedia_special_pages_screen.dart';
import '../niaspedia_recent_changes_screen.dart';

class NiaspediaShortcuts extends StatelessWidget {
  const NiaspediaShortcuts({super.key});

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
              ShortcutsRcTextButton(rcScreen: NiaspediaRecentChangesScreen(), color: color),
              ShortcutsSpecialTextButton(
                screen: NiaspediaSpecialPagesScreen(title: 'Wikipedia:Angombakhata'),
                text: 'announcement',
                color: altColor,
              ),
              ShortcutsSpecialTextButton(
                screen: NiaspediaSpecialPagesScreen(title: 'Wikipedia:Bawagöli zato'),
                text: 'community_portal',
                color: color,
              ),
              ShortcutsSpecialTextButton(
                screen: NiaspediaSpecialPagesScreen(title: 'Wikipedia:Monganga afo'),
                text: 'village_pump',
                color: altColor,
              ),
              ShortcutsSpecialTextButton(
                screen: NiaspediaSpecialPagesScreen(title: 'Wikipedia:Nahia wamakori'),
                text: 'sandbox',
                color: color,
              ),
              ShortcutsSpecialTextButton(
                screen: NiaspediaSpecialPagesScreen(title: 'Fanolo:Fanolo'),
                text: 'help',
                color: altColor,
              ),
              ShortcutsSpecialTextButton(
                screen: NiaspediaSpecialPagesScreen(title: 'Wikipedia:Sangai halöŵö'),
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
