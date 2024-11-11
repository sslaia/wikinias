import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({
    super.key,
    required this.tooltip,
    required this.text,
    required WebViewController controller,
  }) : _controller = controller;

  final String tooltip;
  final String text;
  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => IconButton(
        icon: Icon(Icons.arrow_back_ios_outlined,
            color: (wiki.name == 'Wiktionary')
                ? Colors.black87
                : Colors.white70),
        tooltip: tooltip.tr(),
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          if (await _controller.canGoBack()) {
            await _controller.goBack();
          } else {
            messenger.showSnackBar(
              SnackBar(
                content: Text(text).tr(),
              ),
            );
            return;
          }
        },
      ),
    );
  }
}