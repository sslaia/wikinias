import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htm_parser;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/random_icon_button.dart';
import 'package:wikinias/app_bar/refresh_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/app_bar/home_icon_button.dart';
import 'package:wikinias/screens/image_screen.dart';
import 'package:wikinias/utils/get_capitalised_title_from_url.dart';
import 'package:wikinias/utils/sanitise_html.dart';
import 'package:wikinias/utils/sanitised_title.dart';

import '../app_bar/view_on_web_icon_button.dart';
import '../providers/settings_provider.dart';
import '../utils/processed_title.dart';
import '../widgets/flexible_page_header.dart';
import '../widgets/footer_section.dart';
import '../app_bar/share_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../app_bar/edit_icon_button.dart';
import '../widgets/page_screen_body.dart';

class NiaspediaPageScreen extends StatefulWidget {
  final String title;

  const NiaspediaPageScreen({super.key, required this.title});

  @override
  State<NiaspediaPageScreen> createState() => _NiaspediaPageScreenState();
}

class _NiaspediaPageScreenState extends State<NiaspediaPageScreen> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _fetchPageContent();
  }

  void _fetchPageContent() {
    _futurePageContent = _wikiApiService.fetchNiaspediaPage(widget.title);
  }

  void _navigateToRandomPage(String newRandomTitle) {
    // final String title = url.substring(7);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => NiaspediaPageScreen(title: newRandomTitle),
      ),
    );
  }

  void _navigateToNewPage(String url) {
    final newPageTitle = sanitisedTitle(url.substring(6));
    // Navigate to new page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => NiaspediaPageScreen(title: newPageTitle),
      ),
    );
  }

  void _navigateToCreatePage(String url) {
    final String newTitle = getCapitalisedTitleFromUrl(url);
    final String fullEditUrl =
        'https://nia.wikipedia.org/wiki/$newTitle?action=edit&section=all';
    // Navigate to create page
    launchUrl(Uri.parse(fullEditUrl));
    // Or send it to a new page form
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
    // BottomAppBar configuration
    final List<Widget> barChildren = [
      BottomAppBarLabelButton(label: 'niaspedia'),
      const Spacer(),
      HomeIconButton(),
      RefreshIconButton(destination: NiaspediaPageScreen(title: widget.title)),
      ShortcutsIconButton(),
      RandomIconButton(onRandomTitleFound: _navigateToRandomPage),
    ];

    final String pageUrl = 'https://nia.m.wikipedia.org/wiki/${widget.title}';
    final Color color = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => Scaffold(
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
                flexibleSpace: FlexiblePageHeader(
                  image: settingsProvider.getProjectPageImage(),
                ),
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

                        if (snapshot.hasData) {
                          String sanitizedHtml = sanitiseHtml(snapshot.data!);
                          return PageScreenBody(
                            html: sanitizedHtml,
                            baseUrl: settingsProvider.getProjectUrl(),
                            onExistentLinkTap: _navigateToNewPage,
                            onNonExistentLinkTap: _navigateToCreatePage,
                            onImageLinkTap: _navigateToImagePage,
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    FooterSection(footer: settingsProvider.getProjectFooter()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
