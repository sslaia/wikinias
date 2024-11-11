import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class WikiTools extends StatelessWidget {
  const WikiTools({
    super.key,
    required this.tool,
    required this.label,
    required this.color,
    required WebViewController controller,
  }) : _controller = controller;

  final Color color;
  final String tool;
  final String label;
  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => TextButton(
        onPressed: () {
          _controller.loadRequest(
            Uri.parse(
                '${wiki.url}/wiki/${wiki.name}:$tool'),
          );
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