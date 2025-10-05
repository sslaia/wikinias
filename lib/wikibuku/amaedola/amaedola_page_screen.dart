import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_bar/label_bottom_app_bar.dart';
import '../../services/wikinias_api_service.dart';
import '../../widgets/flexible_page_header.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import '../../constants.dart';
import '../widgets/wikibuku_page_screen_body.dart';
import 'amaedola_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final String title = widget.title;

    return Scaffold(
      bottomNavigationBar: LabelBottomAppBar(label: 'Amaedola', color: amaedolaColor, destination: AmaedolaScreen(),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: amaedolaColor),
            title: Text('Amaedola: ${title.substring(9)}', style: TextStyle(color: amaedolaColor)),
            floating: true,
            expandedHeight: 250,
            flexibleSpace: FlexiblePageHeader(image: amaedolaImage),
            actions: [
              // Share button
              IconButton(
                tooltip: 'share'.tr(),
                icon: Icon(Icons.share_outlined, color: amaedolaColor),
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(uri: Uri.parse('$wbUrl$title')),
                  );
                },
              ),
              // Edit button
              IconButton(
                tooltip: 'edit'.tr(),
                icon: Icon(Icons.edit_outlined),
                color: amaedolaColor,
                onPressed: () {
                  launchUrl(Uri.parse('$wbUrl$title?action=edit&section=all'));
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
                          ? WikibukuPageScreenBody(html: snapshot.data!)
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
                  child: HtmlWidget(wikibukuFooter, textStyle: TextStyle(fontSize: 9),),
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
