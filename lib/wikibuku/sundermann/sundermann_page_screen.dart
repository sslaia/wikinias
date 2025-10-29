import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikinias/screens/image_screen.dart';
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
    final String pageUrl =
        'https://incubator.m.wikimedia.org/wiki/Wb/nia/${widget.title}';
    final String sundermannImage = "assets/images/bowogafasi.webp";
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleSmall
        ?.copyWith(color: Theme.of(context).colorScheme.primary);

    return Scaffold(
      bottomNavigationBar: LabelBottomAppBar(label: 'wikibuku_sundermann'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
            title: Text(
              widget.title.substring(18),
              style: titleStyle,
            ),
            floating: true,
            expandedHeight: 230,
            flexibleSpace: FlexiblePageHeader(image: sundermannImage),
            actions: [
              ShareIconButton(url: pageUrl),
              EditIconButton(url: '$pageUrl?action=edit&section=all'),
              ViewOnWebIconButton(url: pageUrl),
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
                            baseUrl: baseUrl,
                            onExistentLinkTap: _navigateToNewPage,
                            onNonExistentLinkTap: _navigateToCreatePage,
                            onImageLinkTap: _navigateToImagePage,
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
