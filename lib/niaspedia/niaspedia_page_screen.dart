import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikinias/utils/sanitised_title.dart';

import '../app_bar/view_on_web_icon_button.dart';
import '../utils/get_capitalised_title_from_url.dart';
import '../utils/processed_title.dart';
import '../widgets/flexible_page_header.dart';
import '../widgets/footer_section.dart';
import '../app_bar/share_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../app_bar/edit_icon_button.dart';
import 'widgets/niaspedia_footer.dart';
import 'widgets/niaspedia_page_bottom_app_bar.dart';
import '../constants.dart';

class NiaspediaPageScreen extends StatefulWidget {
  final String title;

  const NiaspediaPageScreen({super.key, required this.title});

  @override
  State<NiaspediaPageScreen> createState() => _NiaspediaPageScreenState();
}

class _NiaspediaPageScreenState extends State<NiaspediaPageScreen> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futurePageContent = _wikiApiService.fetchNiaspediaPage(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final String url = '$npUrl${widget.title}';

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: NiaspediaPageBottomAppBar(title: widget.title),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: npColor),
              title: Text(processedTitle(widget.title), style: TextStyle(color: npColor)),
              floating: true,
              expandedHeight: 250,
              flexibleSpace: FlexiblePageHeader(image: npPageImage),
              actions: [
                ShareIconButton(color: npColor, url: url),
                EditIconButton(color: npColor, url: '$url?action=edit&section=all'),
                ViewOnWebIconButton(url: url, color: npColor),
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
                  FooterSection(attribution: niaspediaFooter)
                ],
              ),
            ),
          ],
        ),
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
              // Handle the blue link
              onTapUrl: (url) {
                if (url.startsWith('/wiki/')) {
                  final newPageTitle = url.substring(6);

                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) =>
                          NiaspediaPageScreen(title: sanitisedTitle(newPageTitle)),
                    ),
                  );
                  return true;
                }
                // Handle the red link
                if (url.startsWith('/w/')) {
                  final String newTitle = getCapitalisedTitleFromUrl(url);
                  final newUrl = '$npUrl$newTitle';

                  launchUrl(Uri.parse('$newUrl?action=edit&section=all'));
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
