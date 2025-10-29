import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/flexible_page_header.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import 'stories_introduction.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final String storiesImage = "assets/images/stories.webp";
    final String spacerImage = "assets/images/ni'owewemagai.webp";
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleSmall
        ?.copyWith(color: Theme.of(context).colorScheme.primary);
    final TextStyle? headingStyle = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.primary, fontFamily: 'Gelasio', fontWeight: FontWeight.w700);

    return SafeArea(
      child: Scaffold(
        // bottomNavigationBar: BottomAppBar(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: color),
              title: Text(
                'Nidunö-dunö',
                style: titleStyle,
              ),
              floating: true,
              expandedHeight: 250,
              flexibleSpace: FlexiblePageHeader(image: storiesImage),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Ngawalö nidunö-dunö ba li Niha',
                    style: headingStyle,
                  ),
                  SizedBox(height: 16),
                  Image.asset(spacerImage, height: 30, fit: BoxFit.fitHeight),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HtmlWidget(
                      storiesIntroduction,
                      renderMode: RenderMode.column,
                      textStyle: TextStyle(fontFamily: 'Gelasio'),
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
                    child: HtmlWidget(
                      wikibukuFooter,
                      textStyle: TextStyle(fontSize: 9),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
