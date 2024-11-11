import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class RecentChanges extends StatelessWidget {
  const RecentChanges({
    super.key,
    required this.label,
    required WebViewController controller,
  }) : _controller = controller;

  final String label;
  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => TextButton(
        onPressed: () {
          if (wiki.name == 'Wb/nia/Wikibooks') {
            _controller.loadRequest(
              Uri.parse(
                  '${wiki.url}/wiki/Special:RecentChanges?hidebots=1&translations=filter&hidecategorization=1&hideWikibase=1&limit=250&days=30&urlversion=2&rc-testwiki-project=b&rc-testwiki-code=nia'),
            );
          } else {
            _controller.loadRequest(
              Uri.parse(
                  '${wiki.url}/wiki/Special:RecentChanges'),
            );
          }
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
        child: Text(
          label,
          style: TextStyle(
            color: Color(0xff121298),
          ),
        ).tr(),
      ),
    );
  }
}