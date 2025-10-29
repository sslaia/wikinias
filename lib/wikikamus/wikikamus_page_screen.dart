import 'package:flutter/material.dart';
import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/random_icon_button.dart';
import 'package:wikinias/app_bar/refresh_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/app_bar/home_icon_button.dart';
import 'package:wikinias/screens/image_screen.dart';
import 'package:wikinias/utils/get_lowercase_title_from_url.dart';
import 'package:wikinias/utils/sanitised_title.dart';
import 'package:wikinias/widgets/page_screen_body.dart';

import '../widgets/flexible_page_header.dart';
import '../app_bar/view_on_web_icon_button.dart';
import '../utils/processed_title.dart';
import '../widgets/footer_section.dart';
import '../app_bar/share_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../app_bar/edit_icon_button.dart';
import 'guides/create_new_entry.dart';
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
    _fetchPageContent();
  }

  void _fetchPageContent() {
    _futurePageContent = _wikiApiService.fetchWikikamusPage(widget.title);
  }

  void _navigateToRandomPage(String newRandomTitle) {
    // final String title = url.substring(7);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => WikikamusPageScreen(title: newRandomTitle),
      ),
    );
  }

  void _navigateToNewPage(String url) {
    final newPageTitle = sanitisedTitle(url.substring(6));
    // Navigate to the new page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => WikikamusPageScreen(title: newPageTitle),
      ),
    );
  }

  void _navigateToCreatePage(String url) {
    final String newTitle = getLowercaseTitleFromUrl(url);
    // Navigate to new entry form
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            CreateNewEntry(title: newTitle),
      ),
    );
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
    // BottomAppBar configuration
    final List<Widget> barChildren = [
      BottomAppBarLabelButton(label: 'wikikamus'),
      const Spacer(),
      HomeIconButton(),
      RefreshIconButton(destination:  WikikamusPageScreen(title: widget.title)),
      ShortcutsIconButton(),
      RandomIconButton(onRandomTitleFound: _navigateToRandomPage),
    ];

    final String url = 'https://nia.m.wiktionary.org/wiki/';
    final String pageUrl = 'https://nia.m.wiktionary.org/wiki/${widget.title}';
    final Color color = Theme.of(context).colorScheme.primary;
    final String pageImagePath = "assets/images/ni'obutelai.webp";

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: WikiniasBottomAppBar(children: barChildren),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: color),
              title: Text(
                processedTitle(widget.title),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              floating: true,
              expandedHeight: 200,
              flexibleSpace: FlexiblePageHeader(image: pageImagePath),
              actions: [
                ShareIconButton(url: pageUrl),
                EditIconButton(url: '$pageUrl?action=edit&section=all'),
                ViewOnWebIconButton(url: pageUrl),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    processedTitle(widget.title),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
                              baseUrl: url,
                              onExistentLinkTap: _navigateToNewPage,
                              onNonExistentLinkTap: _navigateToCreatePage,
                              onImageLinkTap: _navigateToImagePage,
                            )
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
