import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';
import 'package:wikinias/shortcuts/shortcuts_widget.dart';

class ShortcutsButton extends StatelessWidget {
  const ShortcutsButton({
    super.key,
    required WebViewController controller,
  }) : _controller = controller;

  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => IconButton(
        tooltip: 'shortcuts'.tr(),
        icon: Icon(Icons.switch_access_shortcut_outlined,
            color: (wiki.name == 'Wiktionary') ? Colors.black87 : Colors.white70),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return ShortcutsWidget(controller: _controller);
            },
          );
        },
      ),
    );
  }
}
