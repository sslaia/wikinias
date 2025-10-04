import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PageScreenBody extends StatelessWidget {
  const PageScreenBody({super.key, required this.html});

  final String html;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            HtmlWidget(
              html,
              renderMode: RenderMode.column,
              textStyle: TextStyle(fontFamily: 'Gelasio', fontSize: 18.0),
              onTapUrl: (url) {
                // if (url.startsWith('/wiki/')) {
                //   final newPageTitle = url.substring(6);
                //
                //   Navigator.of(context).push(
                //     MaterialPageRoute<void>(
                //       builder: (context) =>
                //           WikiniasPageScreen(title: newPageTitle),
                //     ),
                //   );
                //   return true;
                // }
                // For external links, launch them in a browser
                launchUrl(Uri.parse(url));
                return true;
              },
              customStylesBuilder: (element) {
                if (element.classes.contains("mw-heading")) {
                  return {'font-size': '12px', 'font-family': 'Ubuntu'};
                }
                if (element.classes.contains("mw-body-header")) {
                  return {'font-size': '12px', 'font-family': 'Ubuntu'};
                }
                if (element.classes.contains("vector-pinnable-header-label")) {
                  return {'font-size': '12px', 'font-family': 'Ubuntu'};
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
