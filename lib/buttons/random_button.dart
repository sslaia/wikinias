import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class RandomButton extends StatelessWidget {
  const RandomButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required WebViewController controller,
  }) : _controller = controller;

  final String tooltip;
  final IconData icon;
  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => IconButton(
          tooltip: tooltip.tr(),
          icon: Icon(icon,
              color: (wiki.name == 'Wiktionary')
                  ? Colors.black87
                  : Colors.white70),
          onPressed: () {
            if (wiki.name == 'Wb/nia/Wikibooks') {
              _controller.loadRequest(Uri.parse(
                  'https://incubator.m.wikimedia.org/wiki/Special:RandomByTest'));
            } else {
              _controller.loadRequest(
                  Uri.parse('${wiki.url}/wiki/Special:Random'));
            }
          }),
    );
  }
}