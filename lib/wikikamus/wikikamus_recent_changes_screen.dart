import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/home_icon_button.dart';
import 'package:wikinias/app_bar/random_icon_button.dart';
import 'package:wikinias/app_bar/refresh_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/wikikamus/wikikamus_page_screen.dart';

import '../app_bar/view_on_web_icon_button.dart';
import '../models/recent_changes.dart';
import '../services/wikinias_api_service.dart';

class WikikamusRecentChangesScreen extends StatefulWidget {
  const WikikamusRecentChangesScreen({super.key});

  @override
  State<WikikamusRecentChangesScreen> createState() =>
      _WikikamusRecentChangesScreenState();
}

class _WikikamusRecentChangesScreenState
    extends State<WikikamusRecentChangesScreen> {
  final WikiniasApiService apiService = WikiniasApiService();
  late Future<List<RecentChanges>> futureRecentChanges;

  @override
  void initState() {
    futureRecentChanges = apiService.fetchWikikamusRecentChanges(limit: 50);
    super.initState();
  }

  void _navigateToRandomPage(String newRandomTitle) {
    // final String title = url.substring(7);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => WikikamusPageScreen(title: newRandomTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // BottomAppBar configuration
    final List<Widget> barChildren = [
      BottomAppBarLabelButton(label: 'wikikamus'),
      const Spacer(),
      HomeIconButton(),
      RefreshIconButton(destination: WikikamusRecentChangesScreen()),
      ShortcutsIconButton(),
      RandomIconButton(onRandomTitleFound: _navigateToRandomPage),
    ];
    final String url =
        'https://nia.wiktionary.org/wiki/Spesial:Perubahan_terbaru?hidebots=1&hideWikibase=1&hideWikifunctions=1&limit=50&days=7&enhanced=1&urlversion=2';

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text(
          'recent_changes'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [ViewOnWebIconButton(url: url)],
      ),
      bottomNavigationBar: WikiniasBottomAppBar(children: barChildren),
      body: FutureBuilder(
        future: futureRecentChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final List<RecentChanges> items = snapshot.data!;

            if (items.isEmpty) {
              return Center(child: Text('no_data'.tr()));
            }
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                String? summary;
                if (item.comment != null || item.comment != '') {
                  summary = item.comment;
                } else {
                  summary = 'no_summary'.tr();
                }
                return ListTile(
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${item.user} (${item.type}): $summary'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("'error'.tr(): ${snapshot.error}"));
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
