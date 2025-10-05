import 'package:flutter/material.dart';
import 'package:wikinias/widgets/flexible_page_header.dart';
import 'package:wikinias/widgets/footer_section.dart';

import 'sundermann_screen.dart';
import '../../app_bar/label_bottom_app_bar.dart';
import '../../app_bar/view_on_web_icon_button.dart';
import '../../services/wikinias_api_service.dart';
import '../../app_bar/edit_icon_button.dart';
import '../../app_bar/share_icon_button.dart';
import '../widgets/wikibuku_footer.dart';
import '../../constants.dart';
import '../widgets/wikibuku_page_screen_body.dart';

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

  @override
  Widget build(BuildContext context) {
    final String title = widget.title;

    return Scaffold(
      bottomNavigationBar: LabelBottomAppBar(label: 'Kamus Nias-Jerman', color: sundermannColor, destination: SundermannScreen(),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: sundermannColor),
            title: Text(title.substring(18), style: TextStyle(color: sundermannColor)),
            floating: true,
            expandedHeight: 230,
            flexibleSpace: FlexiblePageHeader(image: sundermannImage),
            actions: [
              ShareIconButton(color: sundermannColor, url: '$wbUrl$title'),
              EditIconButton(color: sundermannColor, url: '$wbUrl$title?action=edit&section=all'),
              ViewOnWebIconButton(color: sundermannColor, url: '$wbUrl$title'),
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
                FooterSection(attribution: wikibukuFooter),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
