import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikinias/wikibuku/bible/bible_screen.dart';

import '../../app_bar/label_bottom_app_bar.dart';
import '../../services/wikinias_api_service.dart';
import '../../widgets/page_screen_body.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import '../../constants.dart';

class BibleChapterScreen extends StatefulWidget {
  final String title;

  const BibleChapterScreen({super.key, required this.title});

  @override
  State<BibleChapterScreen> createState() => _BibleChapterScreenState();
}

class _BibleChapterScreenState extends State<BibleChapterScreen> {
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
      bottomNavigationBar: LabelBottomAppBar(label: "Sura Ni'amoni'ö", color: bibleColor, destination: BibleScreen(),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: bibleColor),
            title: Text(title, style: TextStyle(color: bibleColor)),
            floating: true,
            expandedHeight: 200,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(bibleImage, fit: BoxFit.fitHeight),
                  ),
                ),
              ],
            ),
            actions: [
              // Share button
              IconButton(
                tooltip: 'share'.tr(),
                icon: Icon(Icons.share_outlined, color: bibleColor),
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(uri: Uri.parse('$wbUrl$title')),
                  );
                },
              ),
              // Edit button
              IconButton(
                tooltip: 'edit'.tr(),
                onPressed: () {
                  launchUrl(Uri.parse('$wbUrl$title?action=edit&section=all'));
                },
                icon: Icon(Icons.edit_outlined, color: bibleColor),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                FutureBuilder(
                  future: _futurePageContent,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return snapshot.hasData
                        ? PageScreenBody(html: snapshot.data!)
                        : const Center(child: CircularProgressIndicator());
                  },
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
