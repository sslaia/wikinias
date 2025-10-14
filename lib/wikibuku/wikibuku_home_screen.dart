import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../services/content_service.dart';
import '../widgets/footer_section.dart';
import '../widgets/create_new_page_form.dart';
import '../widgets/create_new_page_text_button.dart';
import '../widgets/featured_dyk_section.dart';
import '../widgets/featured_story_section.dart';
import '../widgets/main_header_section.dart';
import '../widgets/main_header_image.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/spacer_image.dart';
import 'widgets/wikibuku_portal.dart';
import 'widgets/wikibuku_search_section.dart';
import 'widgets/wikibuku_bottom_app_bar.dart';
import 'widgets/wikibuku_footer.dart';

class WikibukuHomeScreen extends StatefulWidget {
  const WikibukuHomeScreen({super.key});

  @override
  State<WikibukuHomeScreen> createState() => _WikibukuHomeScreenState();
}

class _WikibukuHomeScreenState extends State<WikibukuHomeScreen> {
  final GlobalKey<ScaffoldState> wikibukuScaffoldKey =
      GlobalKey<ScaffoldState>();

  late Future<Map<String, dynamic>> _futureContent;

  @override
  void initState() {
    super.initState();
    _futureContent = _fetchContent();
  }

  Future<Map<String, dynamic>> _fetchContent() async {
    final contentService = Provider.of<ContentService>(context, listen: false);

    final results = await Future.wait([
      contentService.getFeaturedStory(),
      contentService.getFeaturedDyk(),
    ]);

    return {'story': results[0], 'dyk': results[1]};
  }

  @override
  Widget build(BuildContext context) {
    final String wikibukuMainImage = 'assets/images/figa.webp';
    final String wikibukuUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
    final String footer = wikibukuFooter;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: wikibukuScaffoldKey,
          drawer: WikiniasDrawerMenu(),
          bottomNavigationBar: WikibukuBottomAppBar(),
          body: FutureBuilder<Map<String, dynamic>>(
            future: _futureContent,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('no_data').tr());
              }
              final featuredStory = snapshot.data!['story'] ?? {};
              final featuredDyk = snapshot.data!['dyk'] ?? {};

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MainHeaderImage(image: wikibukuMainImage),
                      const SizedBox(height: 28.0),
                      MainHeaderSection(),
                      const SizedBox(height: 28.0),
                      const WikibukuSearchSection(),
                      const SizedBox(height: 28.0),
                      FeaturedStorySection(storyData: featuredStory),
                      const SizedBox(height: 28.0),
                      const SpacerImage(),
                      const SizedBox(height: 28.0),
                      FeaturedDykSection(dykData: featuredDyk),
                      const SizedBox(height: 28.0),
                      WikibukuPortal(),
                      const SizedBox(height: 28.0),
                      const SpacerColorBar(imageWidth: 250),
                      CreateNewPageTextButton(
                        label: 'create_new_page',
                        destination: CreateNewPageForm(url: wikibukuUrl),
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
