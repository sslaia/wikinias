import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    required this.icon,
    required this.label,
    required WebViewController controller,
  }) : _controller = controller;

  final IconData icon;
  final String label;
  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => IconButton(
        icon: Icon(icon,
            color: (wiki.name == 'Wiktionary')
                ? Colors.black87
                : Colors.white70),
        tooltip: label.tr(),
        onPressed: () async {
          String? currentUrl = await _controller.currentUrl();
          Share.share(currentUrl!);
        },
      ),
    );
  }
}