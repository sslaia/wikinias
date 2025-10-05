import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikinias/constants.dart';

import '../../utils/get_capitalised_title_from_url.dart';
import '../../utils/sanitised_title.dart';
import '../wikibuku_page_screen.dart';

class WikibukuPageScreenBody extends StatelessWidget {
  const WikibukuPageScreenBody({super.key, required this.html});

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
                if (url.startsWith('/wiki/Wb/nia/')) {
                  final newPageTitle = url.substring(13);

                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) =>
                          WikibukuPageScreen(title: sanitisedTitle(newPageTitle)),
                    ),
                  );
                  return true;
                }
                // Handle the red link
                if (url.startsWith('/w/')) {
                  final String newTitle = getCapitalisedTitleFromUrl(url);
                  // removed additional incubator prefix from the wikibooks links
                  final String checkedTitle = newTitle.replaceAll('Wb/nia/', '');
                  final newUrl = '$wbUrl$checkedTitle';

                  launchUrl(Uri.parse('$newUrl?action=edit&section=all'));
                  return true;
                }
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