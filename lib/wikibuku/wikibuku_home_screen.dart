import 'package:flutter/material.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../widgets/footer_section.dart';
import '../widgets/create_new_page_form.dart';
import '../widgets/create_new_page_text_button.dart';
import '../widgets/dyk_section.dart';
import '../widgets/featured_story.dart';
import '../widgets/main_header.dart';
import '../widgets/main_header_image.dart';
import '../widgets/spacer_color_bar.dart';
import '../widgets/spacer_image.dart';
import 'widgets/wikibuku_drawer_section.dart';
import 'widgets/wikibuku_portal.dart';
import 'widgets/wikibuku_search_section.dart';
import 'widgets/wikibuku_bottom_app_bar.dart';
import 'widgets/wikibuku_footer.dart';

class WikibukuHomeScreen extends StatelessWidget {
  WikibukuHomeScreen({super.key});

  final GlobalKey<ScaffoldState> wikibukuScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final String project = 'Wikibuku';
    final Color color = Color(0xff9b00a1);
    final String image = 'assets/images/figa.webp';
    final String attribution = wikibukuFooter;
    final String url = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: wikibukuScaffoldKey,
          drawer: WikiniasDrawerMenu(project: project, image: image,  color: color, projectDrawerSection: WikibukuDrawerSection()),
          bottomNavigationBar: WikibukuBottomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const WikibukuSearchSection(),
                  const SizedBox(height: 28.0),
                  MainHeader(project: project, color: color),
                  MainHeaderImage(image: image),
                  const SizedBox(height: 28.0),
                  FeaturedStory(project: project, color: color),
                  const SizedBox(height: 28.0),
                  const SpacerImage(),
                  const SizedBox(height: 28.0),
                  DykSection(color: color),
                  const SizedBox(height: 28.0),
                  WikibukuPortal(color: color),
                  const SizedBox(height: 28.0),
                  const SpacerColorBar(imageWidth: 250),
                  CreateNewPageTextButton(label: 'create_new_page', destination: CreateNewPageForm(url: url, color: color)),
                  FooterSection(attribution: attribution),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
