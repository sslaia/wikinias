import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikinias/constants.dart';
import 'package:wikinias/utils/sanitised_title.dart';
import 'package:wikinias/widgets/flexible_page_header.dart';
import 'package:wikinias/widgets/footer_section.dart';

import '../app_bar/view_on_web_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../utils/processed_title.dart';
import '../app_bar/edit_icon_button.dart';
import '../app_bar/share_icon_button.dart';
import 'widgets/wikibuku_page_bottom_app_bar.dart';
import 'widgets/wikibuku_footer.dart';

class WikibukuPageScreen extends StatefulWidget {
  final String title;

  const WikibukuPageScreen({super.key, required this.title});

  @override
  State<WikibukuPageScreen> createState() => _WikibukuPageScreenState();
}

class _WikibukuPageScreenState extends State<WikibukuPageScreen> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futurePageContent = _wikiApiService.fetchWikibukuPage('Wb/nia/${widget.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final String url = '$wbUrl${widget.title}';

    return Scaffold(
      bottomNavigationBar: WikibukuPageBottomAppBar(title: widget.title),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: wbColor),
            title: Text(processedTitle(widget.title), style: TextStyle(color: wbColor)),
            floating: true,
            expandedHeight: 250,
            flexibleSpace: FlexiblePageHeader(image: wbPageImage),
            actions: [
              ShareIconButton(color: wbColor, url: url),
              EditIconButton(color: wbColor, url: '$url?action=edit&section=all'),
              ViewOnWebIconButton(url: url, color: wbColor),
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
                        ? PageBody(html: snapshot.data!)
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
                FooterSection(attribution: wikibukuFooter),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.html});

  final String html;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            HtmlWidget(
              html,
              renderMode: RenderMode.column,
              textStyle: TextStyle(fontFamily: 'Gelasio', fontSize: 18.0),
              onTapUrl: (url) {
                if (url.startsWith('/wiki/Wb/nia/')) {
                  final newPageTitle = url.substring(13);

                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) =>
                          WikibukuPageScreen(title: sanitisedTitle(newPageTitle)),
                    ),
                  );
                  return true;
                }
                // For external links, launch them in a browser
                launchUrl(Uri.parse(url));
                return true;
              },
              customStylesBuilder: (element) {
                if (element.classes.contains("mw-heading")) {
                  return {'font-size': '12px', 'font-family': 'Ubuntu'};
                }
                if (element.classes.contains("mw-body-header")) {
                  return {'font-size': '12px', 'font-family': 'Ubuntu'};
                }
                if (element.classes.contains("vector-pinnable-header-label")) {
                  return {'font-size': '12px', 'font-family': 'Ubuntu'};
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
