import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/refresh_icon_button.dart';
import 'package:wikinias/app_bar/home_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/screens/image_screen.dart';
import 'package:wikinias/utils/sanitised_title.dart';
import 'package:wikinias/wikibuku/widgets/random_icon_button2.dart';

import '../widgets/flexible_page_header.dart';
import '../widgets/footer_section.dart';
import '../app_bar/view_on_web_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../utils/processed_title.dart';
import '../app_bar/edit_icon_button.dart';
import '../app_bar/share_icon_button.dart';
import '../widgets/page_screen_body.dart';
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

  void _navigateToRandomPage(String newRandomTitle) {
    // final String title = newRandomTitle.substring(7);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikibukuPageScreen(title: newRandomTitle),
      ),
    );
  }

  void _navigateToNewPage(String url) {
    final newPageTitle = sanitisedTitle(url.substring(6));
    final String title = newPageTitle.substring(7);
    // Navigate to new page
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikibukuPageScreen(title: title),
      ),
    );
  }

  void _navigateToCreatePage(String newTitle) {
    final String fullEditUrl =
        'https://incubator.wikimedia.org/wiki/$newTitle?action=edit&section=all';
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

  void _refreshThePage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikibukuPageScreen(title: widget.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // BottomAppBar configuration
    final List<Widget> barChildren = [
      BottomAppBarLabelButton(label: 'wikibuku'),
      const Spacer(),
      HomeIconButton(),
      RefreshIconButton(destination: WikibukuPageScreen(title: widget.title)),
      ShortcutsIconButton(),
      RandomIconButton2(onRandomButtonTap: _navigateToRandomPage),
    ];

    final String baseUrl = 'https://incubator.m.wikimedia.org/wiki/';
    final String pageUrl =
        'https://incubator.m.wikimedia.org/wiki/Wb/nia/${widget.title}';
    final String pageImagePath = "assets/images/bowogafasi.webp";

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: WikiniasBottomAppBar(children: barChildren),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.primary,
              ),
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
                              baseUrl: baseUrl,
                              onExistentLinkTap: _navigateToNewPage,
                              onNonExistentLinkTap: _navigateToCreatePage,
                              onImageLinkTap: _navigateToImagePage,
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
