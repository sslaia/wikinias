import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/nias_keyboard.dart';
import '../app_bar/share_icon_button.dart';
import '../widgets/flexible_page_header.dart';

class NiasKeyboardScreen extends StatelessWidget {
  const NiasKeyboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String url = 'https://niaskeyboard.blogspot.com/2021/04/anysoftkeyboard-memasang-huruf-o-dan-w.html';
    const String html = niasKeyboard;
    final Color color = Theme.of(context).colorScheme.primary;
    final double bodyFontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: color),
              title: Text('nias_keyboard', style: TextStyle(fontSize: bodyFontSize * 1.0, color: color)).tr(),
              floating: true,
              expandedHeight: 230,
              flexibleSpace: FlexiblePageHeader(image: "assets/images/nias-keyboard.webp"),
              actions: [
                ShareIconButton(color: color, url: url),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(
                  html,
                  textStyle: TextStyle(fontFamily: 'Gelasio'),
                  onTapUrl: (url) {
                    launchUrl(Uri.parse(url));
                    return true;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
