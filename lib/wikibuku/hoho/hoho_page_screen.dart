import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../widgets/flexible_page_header.dart';
import '../../app_bar/edit_icon_button.dart';
import '../../app_bar/label_bottom_app_bar.dart';
import '../../app_bar/share_icon_button.dart';
import '../../services/wikinias_api_service.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import '../../constants.dart';
import '../widgets/wikibuku_page_screen_body.dart';
import 'hoho_screen.dart';

class HohoPageScreen extends StatefulWidget {
  final String title;

  const HohoPageScreen({super.key, required this.title});

  @override
  State<HohoPageScreen> createState() => _BibleChapterScreenState();
}

class _BibleChapterScreenState extends State<HohoPageScreen> {
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
      bottomNavigationBar: LabelBottomAppBar(label: 'Hoho', color: hohoColor, destination: HohoScreen(),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: hohoColor),
            title: Text(title, style: TextStyle(color: hohoColor)),
            floating: true,
            expandedHeight: 250,
            flexibleSpace: FlexiblePageHeader(image: hohoImage),
            actions: [
              ShareIconButton(color: hohoColor, url: '$wbUrl$title'),
              EditIconButton(color: hohoColor, url: '$wbUrl$title?action=edit&section=all'),
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
                        ? WikibukuPageScreenBody(html: snapshot.data!)
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
