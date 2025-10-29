import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikinias/screens/image_screen.dart';

import '../../widgets/flexible_page_header.dart';
import '../../app_bar/edit_icon_button.dart';
import '../../app_bar/label_bottom_app_bar.dart';
import '../../app_bar/share_icon_button.dart';
import '../../services/wikinias_api_service.dart';
import '../../widgets/page_screen_body.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import '../wikibuku_page_screen.dart';

class HohoPageScreen extends StatefulWidget {
  final String title;

  const HohoPageScreen({super.key, required this.title});

  @override
  State<HohoPageScreen> createState() => _BibleChapterScreenState();
}

class _BibleChapterScreenState extends State<HohoPageScreen> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futurePageContent = _wikiApiService.fetchWikibukuPage(
      'Wb/nia/${widget.title}',
    );
  }

  void _navigateToNewPage(String newPageTitle) {
    final String title = newPageTitle.substring(7);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikibukuPageScreen(title: title),
      ),
    );
  }

  void _navigateToCreatePage(String newTitle) {
    final String fullEditUrl =
        'https://incubator.wikimedia.org/wiki/Wb/nia/$newTitle?action=edit&section=all';
    launchUrl(Uri.parse(fullEditUrl));
    // Navigator.of(context).push(
    //   MaterialPageRoute<void>(
    //     builder: (context) =>
    //         CreateNewPageScreen(title: newTitle),
    //   ),
    // );
  }

  void _navigateToImagePage(String imgUrl) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ImageScreen(imagePath: imgUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
    final String pageUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/${widget.title}';
    final String hohoImage = 'assets/images/hoho.webp';
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleSmall
        ?.copyWith(color: Theme.of(context).colorScheme.primary);

    return Scaffold(
      bottomNavigationBar: LabelBottomAppBar(label: 'wikibuku_hoho'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
            title: Text(widget.title, style: titleStyle),
            floating: true,
            expandedHeight: 250,
            flexibleSpace: FlexiblePageHeader(image: hohoImage),
            actions: [
              ShareIconButton(url: pageUrl),
              EditIconButton(url: '$pageUrl?action=edit&section=all'),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                FutureBuilder(
                  future: _futurePageContent,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return snapshot.hasData
                        ? PageScreenBody(
                      html: snapshot.data!,
                      baseUrl: baseUrl,
                      onExistentLinkTap: _navigateToNewPage,
                      onNonExistentLinkTap: _navigateToCreatePage,
                      onImageLinkTap: _navigateToImagePage,
                    )
                        : const Center(child: CircularProgressIndicator());
                  },
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
          ),
        ],
      ),
    );
  }
}
