import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/home_icon_button.dart';
import 'package:wikinias/app_bar/refresh_icon_button.dart';
import 'package:wikinias/app_bar/share_icon_button.dart';
import 'package:wikinias/app_bar/view_on_web_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/courses/courses_footer.dart';
import 'package:wikinias/providers/settings_provider.dart';
import 'package:wikinias/screens/image_screen.dart';
import 'package:wikinias/services/wikinias_api_service.dart';
import 'package:wikinias/utils/processed_title.dart';
import 'package:wikinias/utils/sanitised_title.dart';
import 'package:wikinias/widgets/flexible_page_header.dart';
import 'package:wikinias/widgets/page_screen_body.dart';
import 'package:wikinias/widgets/spacer_image.dart';

class CoursesPage extends StatefulWidget {
  final String title;

  const CoursesPage({super.key, required this.title});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futurePageContent = _wikiApiService.fetchWikikamusPage('Wiktionary:Sulu/${widget.title}');
  }

  void _navigateToNewPage(String url) {
    final newPageTitle = sanitisedTitle(url.substring(6)).replaceAll('Wiktionary:Sulu/', '');
    // Navigate to new page
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CoursesPage(title: newPageTitle),
      ),
    );
  }

  void _navigateToCreatePage(String url) {
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
      BottomAppBarLabelButton(label: 'courses'),
      const Spacer(),
      HomeIconButton(),
      RefreshIconButton(destination: CoursesPage(title: widget.title)),
    ];

    final String pageUrl = 'https://nia.m.wiktionary.org/wiki/Wiktionary:Sulu/${widget.title}';

    return SafeArea(
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => Scaffold(
          bottomNavigationBar: WikiniasBottomAppBar(children: barChildren),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
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
                        return snapshot.hasData
                            ? PageScreenBody(
                          html: snapshot.data!,
                          baseUrl: settingsProvider.getProjectUrl(),
                          onExistentLinkTap: _navigateToNewPage,
                          onNonExistentLinkTap: _navigateToCreatePage,
                          onImageLinkTap: _navigateToImagePage,
                        )
                            : const Center(child: CircularProgressIndicator());
                      },
                    ),
                    const SpacerImage(),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: HtmlWidget(coursesFooter, renderMode: RenderMode.column, textStyle: Theme.of(context).textTheme.bodySmall),
                    ),
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
