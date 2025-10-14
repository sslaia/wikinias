import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app_bar/shortcuts_kb_text_button.dart';
import '../../app_bar/shortcuts_rc_text_button.dart';
import '../../app_bar/shortcuts_special_text_button.dart';
import '../wikibuku_recent_changes_screen.dart';
import '../wikibuku_special_pages_screen.dart';

class WikibukuShortcuts extends StatelessWidget {
  const WikibukuShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final Color altColor = Theme.of(context).colorScheme.secondary;

    return Container(
      width: double.infinity,
      height: 350.0,
      decoration: const BoxDecoration(
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
              ShortcutsRcTextButton(rcScreen: WikibukuRecentChangesScreen(), color: color),
              ShortcutsSpecialTextButton(
                screen: WikibukuSpecialPagesScreen(title: 'Wikibooks:Angombakhata'),
                text: 'announcement',
                color: altColor,
              ),
              ShortcutsSpecialTextButton(
                screen: WikibukuSpecialPagesScreen(title: 'Wikibooks:Bawagöli zato'),
                text: 'community_portal',
                color: color,
              ),
              ShortcutsSpecialTextButton(
                screen: WikibukuSpecialPagesScreen(title: 'Wikibooks:Monganga afo'),
                text: 'village_pump',
                color: altColor,
              ),
              ShortcutsSpecialTextButton(
                screen: WikibukuSpecialPagesScreen(title: 'Wikibooks:Nahia wamakori'),
                text: 'sandbox',
                color: color,
              ),
              ShortcutsSpecialTextButton(
                screen: WikibukuSpecialPagesScreen(title: 'Help:Fanolo'),
                text: 'help',
                color: altColor,
              ),
              ShortcutsSpecialTextButton(
                screen: WikibukuSpecialPagesScreen(title: 'Wikibooks:Sangai halöŵö'),
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
