import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/drawer_about_section.dart';
import 'package:wikinias/app_bar/drawer_font_selection_section.dart';
import 'package:wikinias/app_bar/drawer_header_container.dart';
import 'package:wikinias/app_bar/drawer_language_selection_section.dart';
import 'package:wikinias/app_bar/drawer_mode_section.dart';
import 'package:wikinias/app_bar/drawer_project_selection_section.dart';
import 'package:wikinias/app_bar/drawer_update_service_section.dart';
import 'package:wikinias/app_bar/open_drawer_button.dart';
import 'package:wikinias/app_bar/refresh_home_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/models/featured_content_item.dart';
import 'package:wikinias/services/app_data_service.dart';
import 'package:wikinias/widgets/create_new_page_form.dart';
import 'package:wikinias/widgets/create_new_page_text_button.dart';
import 'package:wikinias/wikibuku/widgets/random_icon_button2.dart';
import 'package:wikinias/wikibuku/widgets/wikibuku_drawer_section.dart';
import 'package:wikinias/wikibuku/wikibuku_page_screen.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../widgets/footer_section.dart';
import '../widgets/featured_dyk_section.dart';
import '../widgets/featured_story_section.dart';
import '../widgets/main_header_section.dart';
import '../widgets/main_header_image.dart';
import '../widgets/portal_text_button.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/spacer_image.dart';
import 'amaedola/amaedola_screen.dart';
import 'bible/bible_screen.dart';
import 'hoho/hoho_screen.dart';
import 'sundermann/sundermann_screen.dart';
import 'songs/songs_screen.dart';
import 'stories/stories_screen.dart';
import 'widgets/wikibuku_search_section.dart';
import 'widgets/wikibuku_footer.dart';

class WikibukuHomeScreen extends StatefulWidget {
  const WikibukuHomeScreen({super.key});

  @override
  State<WikibukuHomeScreen> createState() => _WikibukuHomeScreenState();
}

class _WikibukuHomeScreenState extends State<WikibukuHomeScreen> {
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
      _appDataService.getDailyStory(),
    ]);
    return HomeScreenContent(
      dyk: results[0] as FeaturedContentItem,
      story: results[1] as FeaturedContentItem,
    );
  }

  void _navigateToNewPage(String pageTitle) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => WikibukuPageScreen(title: pageTitle),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> wikibukuScaffold = GlobalKey<ScaffoldState>();

    // Portal configuration
    final List<Map<String, dynamic>> portalData = [
      {'label': 'wikibuku_amaedola', 'destination': const AmaedolaScreen()},
      {'label': 'wikibuku_hoho', 'destination': const HohoScreen()},
      {'label': 'wikibuku_stories', 'destination': const StoriesScreen()},
      {'label': 'wikibuku_bible', 'destination': const BibleScreen()},
      {'label': 'wikibuku_songs', 'destination': const SongsScreen()},
      {'label': 'wikibuku_sundermann', 'destination': const SundermannScreen()},
    ];

    // BottomAppBar configuration
    final List<Widget> barChildren = [
      OpenDrawerButton(),
      BottomAppBarLabelButton(label: 'wikibuku'),
      const Spacer(),
      RefreshHomeIconButton(route: '/wikibuku'),
      ShortcutsIconButton(),
      RandomIconButton2(onRandomButtonTap: _navigateToNewPage),
    ];

    final List<Widget> drawerChildren = [
      DrawerHeaderContainer(),
      WikibukuDrawerSection(),
      DrawerProjectSelectionSection(),
      DrawerLanguageSelectionSection(),
      DrawerFontSelectionSection(),
      DrawerUpdteServiceSection(),
      DrawerModeSection(),
      DrawerAboutSection(),
    ];

    final String wikibukuUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
    final String wikibukuForm = 'preload=Template:Wb/nia/Famörögö wanura';
    final String footer = wikibukuFooter;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: wikibukuScaffold,
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
                      const WikibukuSearchSection(),
                      const SizedBox(height: 28.0),
                      FeaturedStorySection(storyData: content.story),
                      const SizedBox(height: 28.0),
                      const SpacerImage(),
                      const SizedBox(height: 28.0),
                      FeaturedDykSection(dykData: content.dyk),
                      const SizedBox(height: 28.0),
                      // Wikibuku portal
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
                      const SizedBox(height: 28.0),
                      CreateNewPageTextButton(
                        label: 'create_new_page',
                        destination: CreateNewPageForm(url: wikibukuUrl, form: wikibukuForm),
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
  final FeaturedContentItem? story;

  HomeScreenContent({
    required this.dyk,
    required this.story,
  });
}