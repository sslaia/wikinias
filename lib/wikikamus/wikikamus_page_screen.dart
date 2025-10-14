import 'package:flutter/material.dart';

import '../widgets/flexible_page_header.dart';
import '../app_bar/view_on_web_icon_button.dart';
import '../utils/processed_title.dart';
import '../widgets/footer_section.dart';
import '../app_bar/share_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../app_bar/edit_icon_button.dart';
import 'widgets/wikikamus_page_body.dart';
import 'widgets/wikikamus_page_bottom_app_bar.dart';
import 'widgets/wikikamus_footer.dart';

class WikikamusPageScreen extends StatefulWidget {
  final String title;

  const WikikamusPageScreen({super.key, required this.title});

  @override
  State<WikikamusPageScreen> createState() => _WikikamusPageScreenState();
}

class _WikikamusPageScreenState extends State<WikikamusPageScreen> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futurePageContent = _wikiApiService.fetchWikikamusPage(widget.title);
  }

  void _navigateToNewPage(String pageTitle) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikikamusPageScreen(title: pageTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String url = 'https://nia.m.wiktionary.org/wiki/';
    final String pageUrl = 'https://nia.m.wiktionary.org/wiki/${widget.title}';
    final Color color = Theme.of(context).colorScheme.primary;
    final String pageImagePath = "assets/images/ni'obutelai.webp";
    final double bodyFontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: WikikamusPageBottomAppBar(title: widget.title),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: color),
              title: Text(
                processedTitle(widget.title),
                style: TextStyle(color: color, fontSize: bodyFontSize * 1.0),
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
                  FutureBuilder(
                    future: _futurePageContent,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return snapshot.hasData
                          ? WikikamusPageBody(html: snapshot.data!, onInternalLinkTap: _navigateToNewPage, baseUrl: url)
                          : const Center(child: CircularProgressIndicator());
                    },
                  ),
                  FooterSection(footer: wikikamusFooter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

