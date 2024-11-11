import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class NiasKeyboard extends StatelessWidget {
  const NiasKeyboard({
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
          _controller.loadRequest(
            Uri.parse(
                'https://nia.m.wikipedia.org/wiki/Wikipedia:Fafa_wanura_Nias'),
          );
          Navigator.pop(context);
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(8.0),
              side:
              BorderSide(color: wiki.color),
            ),
          ),
        ),
        child: Text(label, style: TextStyle(color: color)).tr(),
      ),
    );
  }
}