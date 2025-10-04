import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  final String title;
  final String html;

  const AboutScreen({super.key, required this.title, required this.html});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(
            color: Colors.white70,
          ),
        title: Text(title, style: TextStyle(color: Colors.white70)).tr(),
        backgroundColor: Color(0xff121298),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: HtmlWidget(
            html,
            textStyle: TextStyle(
              fontFamily: 'Gelasio',
              fontSize: 20.0,
              color: Colors.black87,
            ),
            onTapUrl: (url) {
            //   if (url.startsWith('/wiki/')) {
            //     final newPageTitle = url.substring(6);
            //
            //     Navigator.of(context).push(
            //       MaterialPageRoute<void>(
            //         builder: (context) =>
            //             WikiniasPageScreen(title: newPageTitle),
            //       ),
            //     );
            //     return true;
            //   }
            //   // For external links, launch them in a browser
              launchUrl(Uri.parse(url));
              return true;
            },
          ),
        ),
      ),
    );
  }
}
