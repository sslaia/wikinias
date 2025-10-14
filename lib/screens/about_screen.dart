import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/settings_provider.dart';
import '../widgets/flexible_page_header.dart';

class AboutScreen extends StatelessWidget {
  final String title;
  final String html;

  const AboutScreen({super.key, required this.title, required this.html});

  @override
  Widget build(BuildContext context) {
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;
    final Color color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) => CustomScrollView(
              slivers: [
                SliverAppBar(
                  iconTheme: IconThemeData(color: color),
                  title: Text(title, style: TextStyle(color: color, fontSize: bodyFontSize * 1.0)).tr(),
                  floating: true,
                  expandedHeight: 200,
                  flexibleSpace: FlexiblePageHeader(
                    image: settingsProvider.getProjectPageImage(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HtmlWidget(
                      html,
                      textStyle: TextStyle(
                        fontFamily: 'Gelasio',
                        // color: color,
                        fontSize: bodyFontSize,
                      ),
                      onTapUrl: (url) {
                        launchUrl(Uri.parse(url));
                        return true;
                      },
                    ),
                  ),
                ),
              ],
            )
          ));
        }
}
