import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../services/content_service.dart';
import '../widgets/create_new_page_text_button.dart';
import '../widgets/footer_section.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/spacer_image.dart';
import '../widgets/featured_dyk_section.dart';
import '../widgets/featured_word_section.dart';
import '../widgets/main_header_section.dart';
import '../widgets/main_header_image.dart';
import 'widgets/wikikamus_search_section.dart';
import 'widgets/wikikamus_bottom_app.bar.dart';
import 'widgets/wikikamus_footer.dart';
import 'guides/create_new_entry.dart';

class WikikamusHomeScreen extends StatefulWidget {
  const WikikamusHomeScreen({super.key});

  @override
  State<WikikamusHomeScreen> createState() => _WikikamusHomeScreenState();
}

class _WikikamusHomeScreenState extends State<WikikamusHomeScreen> {
  final GlobalKey<ScaffoldState> wikikamusScaffoldKey =
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
      contentService.getFeaturedWord(),
      contentService.getFeaturedDyk(),
    ]);

    return {'word': results[0], 'dyk': results[1]};
  }

  @override
  Widget build(BuildContext context) {
    final String wikikamusMainImage = 'assets/images/baluse.webp';
    final String footer = wikikamusFooter;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: wikikamusScaffoldKey,
          drawer: WikiniasDrawerMenu(),
          bottomNavigationBar: WikikamusBottomAppBar(),
          body: FutureBuilder<Map<String, dynamic>>(
            future: _futureContent,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('no_data').tr());
              }
              final featuredWord = snapshot.data!['word'] ?? {};
              final featuredDyk = snapshot.data!['dyk'] ?? {};

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MainHeaderImage(image: wikikamusMainImage),
                      const SizedBox(height: 28.0),
                      MainHeaderSection(),
                      const SizedBox(height: 28.0),
                      const WikikamusSearchSection(),
                      const SizedBox(height: 28.0),
                      FeaturedWordSection(wordData: featuredWord),
                      const SizedBox(height: 28.0),
                      const SpacerImage(),
                      const SizedBox(height: 28.0),
                      FeaturedDykSection(dykData: featuredDyk),
                      const SizedBox(height: 28.0),
                      SpacerColorBar(imageWidth: 250),
                      CreateNewPageTextButton(
                        label: 'create_new_entry',
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
