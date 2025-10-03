import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../widgets/create_new_page_text_button.dart';
import '../widgets/footer_section.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/spacer_image.dart';
import '../widgets/dyk_section.dart';
import '../widgets/featured_word.dart';
import '../widgets/main_header.dart';
import '../widgets/main_header_image.dart';
import 'widgets/wikikamus_drawer_section.dart';
import 'widgets/wikikamus_search_section.dart';
import 'widgets/wikikamus_bottom_app.bar.dart';
import 'guides/create_new_entry.dart';

class WikikamusHomeScreen extends StatelessWidget {
  WikikamusHomeScreen({super.key});

  final GlobalKey<ScaffoldState> wikikamusScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: wikikamusScaffoldKey,
          drawer: WikiniasDrawerMenu(project: wkProject, image: wkMainImage,  color: wkColor, projectDrawerSection: WikikamusDrawerSection()),
          bottomNavigationBar: WikikamusBottomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const WikikamusSearchSection(),
                  const SizedBox(height: 28.0),
                  MainHeader(project: wkProject, color: wkColor),
                  MainHeaderImage(image: wkMainImage),
                  const SizedBox(height: 28.0),
                  FeaturedWord(project: wkProject, color: wkColor),
                  const SizedBox(height: 28.0),
                  const SpacerImage(),
                  const SizedBox(height: 28.0),
                  DykSection(color: wkColor),
                  const SizedBox(height: 28.0),
                  SpacerColorBar(imageWidth: 250),
                  CreateNewPageTextButton(label: 'create_new_entry', destination: CreateNewEntry()),
                  FooterSection(attribution: wkFooter),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
