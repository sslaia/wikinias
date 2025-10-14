import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../services/content_service.dart';
import '../widgets/create_new_page_form.dart';
import '../widgets/featured_article_section.dart';
import '../widgets/featured_dyk_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/main_header_section.dart';
import '../widgets/main_header_image.dart';
import '../widgets/spacer_image.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/create_new_page_text_button.dart';
import 'widgets/niaspedia_bottom_app_bar.dart';
import 'widgets/niaspedia_portal.dart';
import 'widgets/niaspedia_search_section.dart';
import 'widgets/niaspedia_footer.dart';

class NiaspediaHomeScreen extends StatefulWidget {
  const NiaspediaHomeScreen({super.key});

  @override
  State<NiaspediaHomeScreen> createState() => _NiaspediaHomeScreenState();
}

class _NiaspediaHomeScreenState extends State<NiaspediaHomeScreen> {
  final GlobalKey<ScaffoldState> niaspediaScaffoldKey =
      GlobalKey<ScaffoldState>();

  late Future<Map<String, dynamic>> _futureContent;

  @override
  void initState() {
    super.initState();
    _futureContent = _fetchDailyContent();
  }

  Future<Map<String, dynamic>> _fetchDailyContent() async {
    final contentService = Provider.of<ContentService>(context, listen: false);

    final results = await Future.wait([
      contentService.getFeaturedArticle(),
      contentService.getFeaturedDyk(),
    ]);

    return {'article': results[0], 'dyk': results[1]};
  }

  @override
  Widget build(BuildContext context) {
    final String niaspediaMainImage = 'assets/images/tolögu.webp';
    final String niaspediaUrl = 'https://nia.m.wikipedia.org/wiki/';
    final String footer = niaspediaFooter;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: niaspediaScaffoldKey,
          drawer: WikiniasDrawerMenu(),
          bottomNavigationBar: NiaspediaBottomAppBar(),
          body: FutureBuilder<Map<String, dynamic>>(
            future: _futureContent,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('no_data').tr());
              }
              final featuredArticle = snapshot.data!['article'] ?? {};
              final featuredDyk = snapshot.data!['dyk'] ?? {};

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MainHeaderImage(image: niaspediaMainImage),
                      const SizedBox(height: 28.0),
                      MainHeaderSection(),
                      const SizedBox(height: 28.0),
                      const NiaspediaSearchSection(),
                      const SizedBox(height: 28.0),
                      FeaturedArticleSection(articleData: featuredArticle),
                      const SizedBox(height: 28.0),
                      const SpacerImage(),
                      const SizedBox(height: 28.0),
                      FeaturedDykSection(dykData: featuredDyk),
                      const SizedBox(height: 28.0),
                      NiaspediaPortal(),
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
