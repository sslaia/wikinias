import 'package:flutter/material.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../widgets/create_new_page_form.dart';
import '../widgets/featured_article.dart';
import '../widgets/dyk_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/main_header.dart';
import '../widgets/main_header_image.dart';
import '../widgets/spacer_image.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/create_new_page_text_button.dart';
import 'widgets/niaspedia_drawer_section.dart';
import 'widgets/niaspedia_portal.dart';
import 'widgets/niaspedia_bottom_app_bar.dart';
import 'widgets/niaspedia_search_section.dart';
import '../constants.dart';

class NiaspediaHomeScreen extends StatelessWidget {
  NiaspediaHomeScreen({super.key});

  final GlobalKey<ScaffoldState> niaspediaScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: niaspediaScaffoldKey,
          drawer: WikiniasDrawerMenu(project: npProject, image: npMainImage,  color: npColor, projectDrawerSection: NiaspediaDrawerSection()),
          bottomNavigationBar: NiaspediaBottomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const NiaspediaSearchSection(),
                  const SizedBox(height: 28.0),
                  MainHeader(project: npProject, color: npColor),
                  MainHeaderImage(image: npMainImage),
                  const SizedBox(height: 28.0),
                  FeaturedArticle(project: npProject, color: npColor),
                  const SizedBox(height: 28.0),
                  const SpacerImage(),
                  const SizedBox(height: 28.0),
                  DykSection(color: npColor),
                  const SizedBox(height: 28.0),
                  NiaspediaPortal(color: npColor),
                  const SizedBox(height: 28.0),
                  const SpacerColorBar(imageWidth: 250),
                  CreateNewPageTextButton(label: 'create_new_page', destination: CreateNewPageForm(url: npUrl, color: npColor)),
                  FooterSection(attribution: npFooter),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

