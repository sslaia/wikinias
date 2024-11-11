import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required WebViewController controller,
  }) : _controller = controller;

  final IconData icon;
  final String tooltip;
  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => IconButton(
        icon: Icon(icon,
            color: (wiki.name == 'Wiktionary')
                ? Colors.black87
                : Colors.white70),
        tooltip: tooltip.tr(),
        onPressed: ()  => _controller.reload(),
      ),
    );
  }
}