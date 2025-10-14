import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screens/image_screen.dart';
import '../../utils/get_lowercase_title_from_url.dart';
import '../../utils/sanitised_title.dart';
import '../guides/create_new_entry_from_word.dart';

typedef InternalLinkCallback = void Function(String title);

class WikikamusPageBody extends StatelessWidget {
  const WikikamusPageBody({
    super.key,
    required this.html,
    required this.onInternalLinkTap,
    required this.baseUrl,
  });

  final String html;
  final InternalLinkCallback onInternalLinkTap;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    final baseTextStyle =
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: HtmlWidget(
        html,
        renderMode: RenderMode.column,
        textStyle: baseTextStyle.copyWith(fontFamily: 'Gelasio'),
        onTapUrl: (url) {
          // Handle internal wiki links (blue links)
          if (url.startsWith('/wiki/')) {
            final newPageTitle = sanitisedTitle(url.substring(6));
            // Use the callback to notify the parent screen
            onInternalLinkTap(newPageTitle);
            return true;
          }

          // Handle non-existent pages (red links)
          if (url.startsWith('/w/')) {
            final String newTitle = getLowercaseTitleFromUrl(url);
            // send the new title to the new page form
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) =>
                    CreateNewEntryFromWordScreen(title: newTitle),
              ),
            );
            return true;
          }

          // For all other external links, launch them in a browser
          launchUrl(Uri.parse(url));
          return true;
        },
        onTapImage: (image) {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) =>
                  ImageScreen(imagePath: image.sources.first.url),
            ),
          );
        },
        customStylesBuilder: (element) {
          // Use a relative font size based on the theme's body text for better scaling.
          final double bodyFontSize =
              Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

          if (element.classes.contains("mw-heading")) {
            return {'font-size': '${bodyFontSize * 0.5}pt'};
          }
          if (element.localName == "figure") {
            return {'width': '100%'};
          }
          if (element.classes.contains("new")) {
            return {'color': 'salmon'};
          }
          return null;
        },
      ),
    );
  }
}

String sanitizeImageUrl(String url) {
  if (url.startsWith('file://')) {
    return url.replaceFirst('file://', 'https://');
  }
  if (url.startsWith('//')) {
    return 'https:$url';
  }
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return 'https://$url';
  }
  return url;
}
