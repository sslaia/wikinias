import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/nias_keyboard.dart';
import '../app_bar/share_icon_button.dart';

class NiasKeyboardScreen extends StatelessWidget {
  const NiasKeyboardScreen({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const String url = 'https://niaskeyboard.blogspot.com/2021/04/anysoftkeyboard-memasang-huruf-o-dan-w.html';
    const String html = niasKeyboard;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: color),
              title: Text('nias_keyboard', style: TextStyle(color: color)).tr(),
              floating: true,
              expandedHeight: 250,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "assets/images/nias-keyboard.webp",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ShareIconButton(color: color, url: url),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(
                  html,
                  textStyle: TextStyle(fontFamily: 'Gelasio', fontSize: 18.0),
                  onTapUrl: (url) {
                    launchUrl(Uri.parse(url));
                    return true;
                  },
                ),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: bottomappbar,
        // bottomNavigationBar: BottomAppBar(
        //   child: Row(
        //     children: [
        //       // Project name
        //       Text(
        //         'special_pages',
        //         style: TextStyle(
        //           fontFamily: 'CinzelDecorative',
        //           fontSize: 16.0,
        //           fontWeight: FontWeight.w700,
        //           color: color,
        //         ),
        //       ).tr(),
        //       const Spacer(),
        //       // Home button
        //       IconButton(
        //         tooltip: 'home'.tr(),
        //         icon: Icon(Icons.home_outlined),
        //         color: color,
        //         onPressed: () {
        //           Navigator.pop(context);
        //           Navigator.pushNamed(context, homeDestination);
        //         },
        //       ),
        //       // Refresh button
        //       IconButton(
        //         tooltip: 'refresh'.tr(),
        //         icon: Icon(Icons.refresh_outlined),
        //         color: color,
        //         onPressed: () {
        //           Navigator.pop(context);
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute<void>(
        //               builder: (context) => NiasKeyboardScreen(project: project, color: color),
        //             ),
        //           );
        //         },
        //       ),
        //       // Shortcuts button
        //       IconButton(
        //         tooltip: 'shortcuts'.tr(),
        //         icon: Icon(Icons.switch_access_shortcut_outlined),
        //           color: color,
        //         onPressed: () {
        //           showModalBottomSheet<void>(
        //             context: context,
        //             builder: (BuildContext context) {
        //               return projectShortcuts;
        //             },
        //           );
        //         },
        //       ),
        //       const SizedBox(width: 16.0),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
