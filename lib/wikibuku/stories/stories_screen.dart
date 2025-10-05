import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/flexible_page_header.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import 'stories_introduction.dart';
import '../../constants.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // bottomNavigationBar: BottomAppBar(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: storiesColor),
              title: Text('Nidunö-dunö', style: TextStyle(color: storiesColor)),
              floating: true,
              expandedHeight: 250,
              flexibleSpace: FlexiblePageHeader(image: storiesImage),
            ),
            SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(storiesImage, height: 200, fit: BoxFit.fitHeight),
                SizedBox(height: 16),
                Text('Ngawalö nidunö-dunö ba li Niha', style: titleStyle),
                SizedBox(height: 16),
                Image.asset(spacerImage, height: 30, fit: BoxFit.fitHeight),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(
                    storiesIntroduction,
                    renderMode: RenderMode.column,
                    textStyle: TextStyle(fontFamily: 'Gelasio', fontSize: 18.0),
                    onTapUrl: (url) {
                      launchUrl(Uri.parse(url));
                      return true;
                    },
                  ),
                ),
                SizedBox(height: 16),
                const SpacerImage(),
                SizedBox(height: 32),
                // Attribution
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(wikibukuFooter, textStyle: TextStyle(fontSize: 9),),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),],
        ),
      ),
    );
  }
}
