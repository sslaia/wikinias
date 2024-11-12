import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';
import 'package:wikinias/shortcuts/help_button.dart';
import 'package:wikinias/shortcuts/nias_keyboard.dart';
import 'package:wikinias/shortcuts/recent_changes.dart';
import 'package:wikinias/shortcuts/special_pages.dart';
import 'package:wikinias/shortcuts/wiki_tools.dart';

class ShortcutsWidget extends StatelessWidget {
  const ShortcutsWidget({
    super.key,
    required WebViewController controller,
  }) : _controller = controller;

  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350.0,
      decoration: const BoxDecoration(
        color: Color(0xfffaf6ed),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Consumer<WikiProvider>(
        builder: (context, wiki, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'shortcuts',
              style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54),
            ).tr(),
            const SizedBox(height: 20.0),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              children: [
                RecentChanges(label: 'recent_changes', controller: _controller),
                SpecialPages(label: 'special_pages', controller: _controller),
                WikiTools(tool: 'Angombakhata', label: 'announcement', color: Color(0xff121298), controller: _controller),
                WikiTools(tool: 'Bawagöli_zato', label: 'community_portal', color: Color(0xff9b00a1), controller: _controller),
                WikiTools(tool: 'Monganga_afo', label: 'village_pump', color: Color(0xff121298), controller: _controller),
                WikiTools(tool: 'Nahia_wamakori', label: 'sandbox', color: Color(0xff9b00a1), controller: _controller),
                HelpButton(label: 'help', color: Color(0xff121298), controller: _controller),
                WikiTools(tool: 'Sangai_halöŵö', label: 'helpers', color: Color(0xff9b00a1), controller: _controller),
                NiasKeyboard(label: 'nias_keyboard', color: Color(0xff121298), controller: _controller),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
