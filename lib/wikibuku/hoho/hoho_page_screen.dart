import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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

  void _navigateToNewPage(String pageTitle) {
    final String title = pageTitle.substring(7);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikibukuPageScreen(title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
    final String pageUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/${widget.title}';
    final Color color = Theme.of(context).colorScheme.primary;
    final String hohoImage = 'assets/images/hoho.webp';
    final double bodyFontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return Scaffold(
      bottomNavigationBar: LabelBottomAppBar(label: 'wikibuku_hoho'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: color),
            title: Text(widget.title, style: TextStyle(color: color, fontSize: bodyFontSize * 1.0)),
            floating: true,
            expandedHeight: 250,
            flexibleSpace: FlexiblePageHeader(image: hohoImage),
            actions: [
              ShareIconButton(color: color, url: pageUrl),
              EditIconButton(color: color, url: '$pageUrl?action=edit&section=all'),
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
                      onInternalLinkTap: _navigateToNewPage,
                      baseUrl: baseUrl,
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
