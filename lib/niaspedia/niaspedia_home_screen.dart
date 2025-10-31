import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/drawer_about_section.dart';
import 'package:wikinias/app_bar/drawer_font_selection_section.dart';
import 'package:wikinias/app_bar/drawer_language_selection_section.dart';
import 'package:wikinias/app_bar/drawer_mode_section.dart';
import 'package:wikinias/app_bar/drawer_project_selection_section.dart';
import 'package:wikinias/app_bar/drawer_update_service_section.dart';
import 'package:wikinias/app_bar/open_drawer_button.dart';
import 'package:wikinias/app_bar/random_icon_button.dart';
import 'package:wikinias/app_bar/refresh_home_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/models/featured_content_item.dart';
import 'package:wikinias/niaspedia/niaspedia_page_screen.dart';
import 'package:wikinias/niaspedia/niaspedia_portal_screen.dart';
import 'package:wikinias/niaspedia/widgets/niaspedia_drawer_section.dart';
import 'package:wikinias/services/app_data_service.dart';
import 'package:wikinias/widgets/create_new_page_form.dart';
import 'package:wikinias/widgets/section_title.dart';
import '../app_bar/drawer_header_container.dart';
import '../app_bar/wikinias_drawer_menu.dart';
import '../widgets/featured_article_section.dart';
import '../widgets/featured_dyk_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/main_header_section.dart';
import '../widgets/main_header_image.dart';
import '../widgets/portal_text_button.dart';
import '../widgets/spacer_image.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/create_new_page_text_button.dart';
import 'widgets/niaspedia_search_section.dart';
import 'widgets/niaspedia_footer.dart';

class NiaspediaHomeScreen extends StatefulWidget {
  const NiaspediaHomeScreen({super.key});

  @override
  State<NiaspediaHomeScreen> createState() => _NiaspediaHomeScreenState();
}

class _NiaspediaHomeScreenState extends State<NiaspediaHomeScreen> {
  late Future<HomeScreenContent> _futureContent;
  late final AppDataService _appDataService;
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _appDataService = Provider.of<AppDataService>(context, listen: false);
    _appDataService.triggerBackgroundUpdate();
    _futureContent = _fetchScreenContent();

    // for the portal animation
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_scrollController.hasClients) return; // a quick check

      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;

      double targetScroll = (currentScroll >= maxScroll) ? 0.0 : currentScroll + 100.0;

      if (targetScroll > maxScroll) targetScroll = maxScroll;

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<HomeScreenContent> _fetchScreenContent() async {
    final results = await Future.wait([
      _appDataService.getDailyDyk(),
      _appDataService.getDailyArticle(),
    ]);
    return HomeScreenContent(
      dyk: results[0] as FeaturedContentItem,
      article: results[1] as FeaturedContentItem,
    );
  }

  void _navigateToNewPage(String pageTitle) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => NiaspediaPageScreen(title: pageTitle),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> niaspediaScaffold = GlobalKey<ScaffoldState>();
    final Color color = Theme.of(context).colorScheme.primary;

    // Define the data for the portal buttons
    final List<Map<String, dynamic>> portalData = [
      {'label': 'religion', 'destination': const NiaspediaPortalScreen()},
      {'label': 'biology', 'destination': const NiaspediaPortalScreen()},
      {'label': 'government', 'destination': const NiaspediaPortalScreen()},
      {'label': 'geography', 'destination': const NiaspediaPortalScreen()},
      {'label': 'custom', 'destination': const NiaspediaPortalScreen()},
      {'label': 'maths', 'destination': const NiaspediaPortalScreen()},
      {'label': 'media', 'destination': const NiaspediaPortalScreen()},
      {'label': 'history', 'destination': const NiaspediaPortalScreen()},
      {'label': 'science', 'destination': const NiaspediaPortalScreen()},
      {'label': 'technology', 'destination': const NiaspediaPortalScreen()},
    ];

    // BottomAppBar configuration
    final List<Widget> barChildren = [
      OpenDrawerButton(),
      BottomAppBarLabelButton(label: 'niaspedia'),
      const Spacer(),
      RefreshHomeIconButton(route: '/niaspedia'),
      ShortcutsIconButton(),
      RandomIconButton(onRandomTitleFound: _navigateToNewPage),
    ];

    // MenuDrawer items
    final List<Widget> drawerChildren = [
      DrawerHeaderContainer(),
      NiaspediaDrawerSection(),
      DrawerProjectSelectionSection(),
      DrawerLanguageSelectionSection(),
      DrawerFontSelectionSection(),
      DrawerUpdteServiceSection(),
      DrawerModeSection(),
      DrawerAboutSection(),
    ];

    final String footer = niaspediaFooter;
    final String niaspediaUrl = 'https://nia.wikipedia.org/wiki/';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: niaspediaScaffold,
          drawer: WikiniasDrawerMenu(children: drawerChildren),
          // drawer: Builder(
          //   builder: (drawerContext) {
          //     return WikiniasDrawerMenu(
          //       children: drawerChildren,
          //     );
          //   },
          // ),
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
                      const NiaspediaSearchSection(),
                      const SizedBox(height: 28.0),
                      FeaturedArticleSection(articleData: content.article),
                      const SizedBox(height: 28.0),
                      const SpacerImage(),
                      const SizedBox(height: 28.0),
                      FeaturedDykSection(dykData: content.dyk),
                      const SizedBox(height: 28.0),
                      // Niaspedia portal
                      SectionTitle(label: 'portals', color: color),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 36.0,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: portalData.length,
                          itemBuilder: (context, index) {
                            final portal = portalData[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: PortalTextButton(
                                label: portal['label']!,
                                destination: portal['destination'] as Widget,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28.0),
                      const SpacerColorBar(imageWidth: 250),
                      CreateNewPageTextButton(
                        label: 'create_new_page',
                        destination: CreateNewPageForm(url: niaspediaUrl),
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
  final FeaturedContentItem? article;

  HomeScreenContent({required this.dyk, required this.article});
}
