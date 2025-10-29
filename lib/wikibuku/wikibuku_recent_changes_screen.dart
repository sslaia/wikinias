import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/app_bar/bottom_app_bar_label_button.dart';
import 'package:wikinias/app_bar/home_icon_button.dart';
import 'package:wikinias/app_bar/refresh_icon_button.dart';
import 'package:wikinias/app_bar/shortcuts_icon_button.dart';
import 'package:wikinias/app_bar/wikinias_bottom_app_bar.dart';
import 'package:wikinias/wikibuku/widgets/random_icon_button2.dart';
import 'package:wikinias/wikibuku/wikibuku_page_screen.dart';

import '../app_bar/view_on_web_icon_button.dart';
import '../models/recent_changes.dart';
import '../services/wikinias_api_service.dart';

class WikibukuRecentChangesScreen extends StatefulWidget {
  const WikibukuRecentChangesScreen({super.key});

  @override
  State<WikibukuRecentChangesScreen> createState() =>
      _WikibukuRecentChangesScreenState();
}

class _WikibukuRecentChangesScreenState
    extends State<WikibukuRecentChangesScreen> {
  final WikiniasApiService wikiniasApiService = WikiniasApiService();
  late Future<List<RecentChanges>> futureRecentChanges;

  @override
  void initState() {
    futureRecentChanges = wikiniasApiService.fetchWikibukuRecentChanges(
      limit: 50,
    );
    super.initState();
  }

  void _navigateToRandomPage(String newRandomTitle) {
    // final String title = newRandomTitle.substring(7);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WikibukuPageScreen(title: newRandomTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // BottomAppBar configuration
    final List<Widget> barChildren = [
      BottomAppBarLabelButton(label: 'recent_changes'),
      const Spacer(),
      HomeIconButton(),
      RefreshIconButton(destination: WikibukuRecentChangesScreen()),
      ShortcutsIconButton(),
      RandomIconButton2(onRandomButtonTap: _navigateToRandomPage),
    ];
    final String url =
        'https://incubator.wikimedia.org/wiki/Special:RecentChanges?hidebots=1&translations=filter&hidecategorization=1&hideWikibase=1&hideWikifunctions=1&limit=250&days=30&urlversion=2';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
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
                return const Center(child: Text('No data available.'));
              }
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  String? summary;
                  if (item.comment != null || item.comment != '') {
                    summary = item.comment;
                  } else {
                    summary = 'No summary';
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
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
