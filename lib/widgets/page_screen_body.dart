import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PageScreenBody extends StatelessWidget {
  const PageScreenBody({
    super.key,
    required this.html,
    required this.baseUrl,
    required this.onExistentLinkTap,
    required this.onNonExistentLinkTap,
    required this.onImageLinkTap,
  });

  final String html;
  final String baseUrl;
  final void Function(String newPageTitle) onExistentLinkTap;
  final void Function(String newTitle) onNonExistentLinkTap;
  final void Function(String imgUrl) onImageLinkTap;

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
            // Use the callback to notify the parent screen
            onExistentLinkTap(url);
            return true;
          }

          // Handle non-existent pages (red links)
          if (url.startsWith('/w/')) {
            onNonExistentLinkTap(url);
            return true;
          }

          // For all other external links, launch them in a browser
          launchUrl(Uri.parse(url));
          return true;
        },
        onTapImage: (image) {
          onImageLinkTap(image.sources.first.url);
        },

        customStylesBuilder: (element) {
          final double headingStyle =
              Theme.of(context).textTheme.titleSmall?.fontSize ?? 14.0;

          if (element.localName == 'img') {
            return {'max-width': '100%', 'height': 'auto'};
          }
          // this below is a temporary solution
          // as the package renders the wiki headings too big
          if (element.classes.contains('mw-page-title-main')) {
            return {'font-size': '${headingStyle * 0.5}pt'};
          }
          if (element.classes.contains("mw-heading")) {
            return {'font-size': '${headingStyle * 0.5}pt'};
          }
          if (element.classes.contains("mw-heading")) {
            return {'font-size': '${headingStyle * 0.5}pt'};
          }
          if (element.localName == "figure") {
            return {'max-width': '100%', 'height': 'auto'};
          }
          if (element.classes.contains("new")) {
            return {'color': 'sienna'};
          }
          return null;
        },
      ),
    );
  }
}

