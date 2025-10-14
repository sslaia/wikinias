import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_bar/view_on_web_icon_button.dart';
import '../providers/settings_provider.dart';
import '../utils/processed_title.dart';
import '../widgets/flexible_page_header.dart';
import '../widgets/footer_section.dart';
import '../app_bar/share_icon_button.dart';
import '../services/wikinias_api_service.dart';
import '../app_bar/edit_icon_button.dart';
import '../widgets/page_screen_body.dart';
import 'widgets/niaspedia_page_bottom_app_bar.dart';

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

  void _navigateToNewPage(String pageTitle) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NiaspediaPageScreen(title: pageTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String pageUrl = 'https://nia.m.wikipedia.org/wiki/${widget.title}';
    final Color color = Theme.of(context).colorScheme.primary;
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => Scaffold(
          bottomNavigationBar: NiaspediaPageBottomAppBar(title: widget.title),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                iconTheme: IconThemeData(color: color),
                title: Text(
                  processedTitle(widget.title),
                  style: TextStyle(color: color, fontSize: bodyFontSize * 1.0),
                ),
                floating: true,
                expandedHeight: 200,
                flexibleSpace: FlexiblePageHeader(image: settingsProvider.getProjectPageImage()),
                actions: [
                  ShareIconButton(color: color, url: pageUrl),
                  EditIconButton(
                    color: color,
                    url: '$pageUrl?action=edit&section=all',
                  ),
                  ViewOnWebIconButton(url: pageUrl, color: color),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      processedTitle(widget.title),
                      style: TextStyle(color: color, fontSize: bodyFontSize * 1.2, fontWeight: FontWeight.w700),
                    ),
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
                                baseUrl: settingsProvider.getProjectUrl(),
                              )
                            : const Center(child: CircularProgressIndicator());
                      },
                    ),
                    FooterSection(footer: settingsProvider.getProjectFooter()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
