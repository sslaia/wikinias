import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({
    super.key,
    required this.label,
    required this.color,
    required WebViewController controller,
  }) : _controller = controller;

  final String label;
  final Color color;
  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => TextButton(
        onPressed: () {
          if (wiki.name == 'Wb/nia/Wikibooks') {
            _controller.loadRequest(
              Uri.parse('https://incubator.m.wikimedia.org/wiki/Wb/nia/Help:Fanolo'),
            );
          } else {
            _controller.loadRequest(Uri.parse('${wiki.url}/wiki/Fanolo:Fanolo'));
          }
          Navigator.pop(context);
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: wiki.color),
            ),
          ),
        ),
        child: Text(label, style: TextStyle(color: color)).tr(),
      ),
    );
  }
}