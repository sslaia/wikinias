import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';
import 'package:wikinias/widgets/flexible_page_header.dart';

import '../app_bar/view_on_web_icon_button.dart';
import '../utils/processed_title.dart';
import '../widgets/footer_section.dart';
import '../widgets/page_screen_body.dart';
import '../app_bar/share_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../app_bar/edit_icon_button.dart';
import 'widgets/wikikamus_page_bottom_app_bar.dart';
import 'widgets/wikikamus_footer.dart';

class WikikamusPageScreen extends StatefulWidget {
  final String title;

  const WikikamusPageScreen({super.key, required this.title});

  @override
  State<WikikamusPageScreen> createState() => _WikikamusPageScreenState();
}

class _WikikamusPageScreenState extends State<WikikamusPageScreen> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futurePageContent = _wikiApiService.fetchWikikamusPage(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final String url = '$wkUrl${widget.title}';

    return Scaffold(
      bottomNavigationBar: WikikamusPageBottomAppBar(title: widget.title),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: wkColor),
            title: Text(processedTitle(widget.title), style: TextStyle(color: wkColor)),
            floating: true,
            expandedHeight: 250,
            flexibleSpace: FlexiblePageHeader(image: wkPageImage),
            actions: [
              ShareIconButton(color: wkColor, url: url),
              EditIconButton(color: wkColor, url: '$url?action=edit&section=all'),
              ViewOnWebIconButton(url: url, color: wkColor),
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
                FooterSection(attribution: wikikamusFooter),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
