import 'package:flutter/material.dart';
import 'package:wikinias/widgets/flexible_page_header.dart';
import 'package:wikinias/widgets/footer_section.dart';

import '../../widgets/page_screen_body.dart';
import '../wikibuku_page_screen.dart';
import '../../app_bar/label_bottom_app_bar.dart';
import '../../app_bar/view_on_web_icon_button.dart';
import '../../services/wikinias_api_service.dart';
import '../../app_bar/edit_icon_button.dart';
import '../../app_bar/share_icon_button.dart';
import '../widgets/wikibuku_footer.dart';

class SundermannPageScreen extends StatefulWidget {
  final String title;

  const SundermannPageScreen({super.key, required this.title});

  @override
  State<SundermannPageScreen> createState() => _SundermannPageScreenState();
}

class _SundermannPageScreenState extends State<SundermannPageScreen> {
  late Future<String> _futurePageContent;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futurePageContent = _wikiApiService.fetchWikibukuPage(
      'Wb/nia/${widget.title}',
    );
  }

  void _navigateToNewPage(String pageTitle) {
    final String title = pageTitle.substring(7);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikibukuPageScreen(title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
    final String pageUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/${widget.title}';
    final Color color = Theme.of(context).colorScheme.primary;
    final String sundermannImage = "assets/images/bowogafasi.webp";
    final double bodyFontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return Scaffold(
      bottomNavigationBar: LabelBottomAppBar(label: 'wikibuku_sundermann'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: color),
            title: Text(widget.title.substring(18), style: TextStyle(color: color, fontSize: bodyFontSize * 1.0)),
            floating: true,
            expandedHeight: 230,
            flexibleSpace: FlexiblePageHeader(image: sundermannImage),
            actions: [
              ShareIconButton(color: color, url: pageUrl),
              EditIconButton(color: color, url: '$pageUrl?action=edit&section=all'),
              ViewOnWebIconButton(color: color, url: pageUrl),
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
                        ? PageScreenBody(
                      html: snapshot.data!,
                      onInternalLinkTap: _navigateToNewPage,
                      baseUrl: baseUrl,
                    )
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
                FooterSection(footer: wikibukuFooter),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
