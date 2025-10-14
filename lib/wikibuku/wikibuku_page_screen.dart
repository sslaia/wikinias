import 'package:flutter/material.dart';

import '../widgets/flexible_page_header.dart';
import '../widgets/footer_section.dart';
import '../app_bar/view_on_web_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../utils/processed_title.dart';
import '../app_bar/edit_icon_button.dart';
import '../app_bar/share_icon_button.dart';
import '../widgets/page_screen_body.dart';
import 'widgets/wikibuku_page_bottom_app_bar.dart';
import 'widgets/wikibuku_footer.dart';

class WikibukuPageScreen extends StatefulWidget {
  final String title;

  const WikibukuPageScreen({super.key, required this.title});

  @override
  State<WikibukuPageScreen> createState() => _WikibukuPageScreenState();
}

class _WikibukuPageScreenState extends State<WikibukuPageScreen> {
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
    final String baseUrl = 'https://incubator.m.wikimedia.org/wiki/';
    final String pageUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/${widget.title}';
    final Color color = Theme.of(context).colorScheme.primary;
    final String pageImagePath = "assets/images/bowogafasi.webp";
    final double bodyFontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: WikibukuPageBottomAppBar(title: widget.title),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: color),
              title: Text(
                processedTitle(widget.title),
                style: TextStyle(fontSize: bodyFontSize * 1.0, color: color),
              ),
              floating: true,
              expandedHeight: 200,
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
                  Text(
                    processedTitle(widget.title),
                    style: TextStyle(color: color, fontWeight: FontWeight.w700),
                  ),
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
