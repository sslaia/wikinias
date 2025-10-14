import 'package:flutter/material.dart';

import '../widgets/flexible_page_header.dart';
import '../app_bar/view_on_web_icon_button.dart';
import '../utils/processed_title.dart';
import '../widgets/footer_section.dart';
import '../services/wikinias_api_service.dart';
import '../app_bar/edit_icon_button.dart';
import '../app_bar/share_icon_button.dart';
import '../widgets/page_screen_body.dart';
import 'widgets/wikibuku_special_pages_bottom_app_bar.dart';
import 'widgets/wikibuku_footer.dart';

class WikibukuSpecialPagesScreen extends StatefulWidget {
  final String title;

  const WikibukuSpecialPagesScreen({super.key, required this.title});

  @override
  State<WikibukuSpecialPagesScreen> createState() =>
      _WikibukuSpecialPagesScreenState();
}

class _WikibukuSpecialPagesScreenState
    extends State<WikibukuSpecialPagesScreen> {
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
        builder: (context) => WikibukuSpecialPagesScreen(title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String url = 'https://incubator.m.wikimedia.org/wiki/';
    final String pageUrl =
        'https://incubator.m.wikimedia.org/wiki/Wb/nia/${widget.title}';
    final Color color = Theme.of(context).colorScheme.primary;
    final String pageImagePath = "assets/images/ornament2.webp";
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: WikibukuSpecialPagesBottomAppBar(
          title: widget.title,
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: color),
              title: Text(
                processedTitle(widget.title),
                style: TextStyle(color: color, fontSize: bodyFontSize * 1.0),
              ),
              floating: true,
              expandedHeight: 230,
              flexibleSpace: FlexiblePageHeader(image: pageImagePath),
              actions: [
                ShareIconButton(color: color, url: pageUrl),
                EditIconButton(
                  color: color,
                  url: '$pageUrl?action=edit&section=all',
                ),
                ViewOnWebIconButton(url: pageUrl, color: color),
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
                              baseUrl: url,
                            )
                          : const Center(child: CircularProgressIndicator());
                    },
                  ),
                  FooterSection(footer: wikibukuFooter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
