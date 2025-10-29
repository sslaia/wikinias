import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikinias/screens/image_screen.dart';

import '../../app_bar/label_bottom_app_bar.dart';
import '../../services/wikinias_api_service.dart';
import '../../widgets/flexible_page_header.dart';
import '../../widgets/page_screen_body.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import '../wikibuku_page_screen.dart';

class AmaedolaPageScreen extends StatefulWidget {
  final String title;

  const AmaedolaPageScreen({super.key, required this.title});

  @override
  State<AmaedolaPageScreen> createState() => _BibleChapterScreenState();
}

class _BibleChapterScreenState extends State<AmaedolaPageScreen> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futurePageContent = _wikiApiService.fetchWikibukuPage(
      'Wb/nia/${widget.title}',
    );
  }

  void _navigateToNewPage(String newPageTitle) {
    final String title = newPageTitle.substring(7);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikibukuPageScreen(title: title),
      ),
    );
  }

  void _navigateToCreatePage(String newTitle) {
    final String fullEditUrl =
        'https://incubator.wikimedia.org/wiki/Wb/nia/$newTitle?action=edit&section=all';
    launchUrl(Uri.parse(fullEditUrl));
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
    final String title = widget.title;
    final String amaedolaImage = 'assets/images/amaedola.webp';
    final String baseUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleSmall
        ?.copyWith(color: Theme.of(context).colorScheme.primary);

    return Scaffold(
      bottomNavigationBar: LabelBottomAppBar(label: 'wikibuku_amaedola'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text('Amaedola: ${title.substring(9)}', style: titleStyle),
            floating: true,
            expandedHeight: 250,
            flexibleSpace: FlexiblePageHeader(image: amaedolaImage),
            actions: [
              // Share button
              IconButton(
                tooltip: 'share'.tr(),
                icon: Icon(
                  Icons.share_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(uri: Uri.parse('$baseUrl$title')),
                  );
                },
              ),
              // Edit button
              IconButton(
                tooltip: 'edit'.tr(),
                icon: Icon(Icons.edit_outlined),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  launchUrl(
                    Uri.parse('$baseUrl$title?action=edit&section=all'),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder(
                    future: _futurePageContent,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return snapshot.hasData
                          ? PageScreenBody(
                              html: snapshot.data!,
                              baseUrl: baseUrl,
                              onExistentLinkTap: _navigateToNewPage,
                              onNonExistentLinkTap: _navigateToCreatePage,
                              onImageLinkTap: _navigateToImagePage,
                            )
                          : const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                SizedBox(height: 16),
                const SpacerImage(),
                SizedBox(height: 32),
                // Attribution
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    wikibukuFooter,
                    textStyle: TextStyle(fontSize: 9),
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
