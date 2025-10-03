import 'package:flutter/material.dart';

import '../app_bar/view_on_web_icon_button.dart';
import '../utils/processed_title.dart';
import '../widgets/flexible_page_header.dart';
import '../widgets/footer_section.dart';
import '../widgets/page_screen_body.dart';
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

    return Scaffold(
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
                        ? PageScreenBody(html: snapshot.data!)
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
                FooterSection(attribution: niaspediaFooter)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
