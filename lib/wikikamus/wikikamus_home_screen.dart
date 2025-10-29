import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/drawer_about_section.dart';
import 'package:wikinias/app_bar/drawer_font_selection_section.dart';
import 'package:wikinias/app_bar/drawer_header_container.dart';
import 'package:wikinias/app_bar/drawer_language_selection_section.dart';
import 'package:wikinias/app_bar/drawer_project_selection_section.dart';
import 'package:wikinias/app_bar/drawer_update_service_section.dart';
import 'package:wikinias/app_bar/open_drawer_button.dart';
import 'package:wikinias/app_bar/random_icon_button.dart';
import 'package:wikinias/app_bar/refresh_home_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/models/featured_content_item.dart';
import 'package:wikinias/services/app_data_service.dart';
import 'package:wikinias/wikikamus/widgets/wikikamus_drawer_section.dart';
import 'package:wikinias/wikikamus/wikikamus_page_screen.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../models/word.dart';
import '../widgets/create_new_page_text_button.dart';
import '../widgets/footer_section.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/spacer_image.dart';
import '../widgets/featured_dyk_section.dart';
import '../widgets/featured_word_section.dart';
import '../widgets/main_header_section.dart';
import '../widgets/main_header_image.dart';
import 'guides/create_new_entry.dart';
import 'widgets/wikikamus_search_section.dart';
import 'widgets/wikikamus_footer.dart';

class WikikamusHomeScreen extends StatefulWidget {
  const WikikamusHomeScreen({super.key});

  @override
  State<WikikamusHomeScreen> createState() => _WikikamusHomeScreenState();
}

class _WikikamusHomeScreenState extends State<WikikamusHomeScreen> {
  late Future<HomeScreenContent> _futureContent;
  late final AppDataService _appDataService;

  @override
  void initState() {
    super.initState();
    _appDataService = Provider.of<AppDataService>(context, listen: false);
    _appDataService.triggerBackgroundUpdate();
    _futureContent = _fetchScreenContent();
  }

  Future<HomeScreenContent> _fetchScreenContent() async {
    final results = await Future.wait([
      _appDataService.getDailyDyk(),
      _appDataService.getDailyWord(),
    ]);
    return HomeScreenContent(
      dyk: results[0] as FeaturedContentItem,
      word: results[1] as Word,
    );
  }

  void _navigateToNewPage(String pageTitle) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => WikikamusPageScreen(title: pageTitle),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> wikikamusScaffold = GlobalKey<ScaffoldState>();

    // BottomAppBar configuration
    final List<Widget> barChildren = [
      OpenDrawerButton(),
      BottomAppBarLabelButton(label: 'wikikamus'),
      const Spacer(),
      RefreshHomeIconButton(route: '/wikikamus',
      ),
      ShortcutsIconButton(),
      RandomIconButton(onRandomTitleFound: _navigateToNewPage),
    ];

    // MenuDrawer items
    final List<Widget> drawerChildren = [
      DrawerHeaderContainer(),
      WikikamusDrawerSection(),
      DrawerProjectSelectionSection(),
      DrawerLanguageSelectionSection(),
      DrawerFontSelectionSection(),
      DrawerUpdteServiceSection(),
      DrawerAboutSection(),
    ];

    final String footer = wikikamusFooter;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: wikikamusScaffold,
          drawer: Builder(
            builder: (drawerContext) {
              return WikiniasDrawerMenu(
                children: drawerChildren,
              );
            },
          ),
          bottomNavigationBar: WikiniasBottomAppBar(children: barChildren),
          body: FutureBuilder<HomeScreenContent>(
            future: _futureContent,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('no_data').tr());
              }
              final HomeScreenContent content = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MainHeaderImage(),
                      const SizedBox(height: 28.0),
                      MainHeaderSection(),
                      const SizedBox(height: 28.0),
                      const WikikamusSearchSection(),
                      const SizedBox(height: 28.0),
                      FeaturedWordSection(wordData: content.word),
                      const SizedBox(height: 28.0),
                      const SpacerImage(),
                      const SizedBox(height: 28.0),
                      FeaturedDykSection(dykData: content.dyk),
                      const SizedBox(height: 28.0),
                      SpacerColorBar(imageWidth: 250),
                      const SizedBox(height: 28.0),
                      CreateNewPageTextButton(
                        label: 'create_new_page',
                        destination: CreateNewEntry(),
                      ),
                      FooterSection(footer: footer),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeScreenContent {
  final FeaturedContentItem? dyk;
  final Word? word;

  HomeScreenContent({required this.dyk, required this.word});
}