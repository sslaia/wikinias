import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../app_bar/view_on_web_icon_button.dart';
import 'widgets/niaspedia_recent_changes_bottom_app_bar.dart';
import '../models/recent_changes.dart';
import '../services/wikinias_api_service.dart';

class NiaspediaRecentChangesScreen extends StatefulWidget {
  const NiaspediaRecentChangesScreen({super.key});

  @override
  State<NiaspediaRecentChangesScreen> createState() =>
      _NiaspediaRecentChangesScreenState();
}

class _NiaspediaRecentChangesScreenState
    extends State<NiaspediaRecentChangesScreen> {
  final WikiniasApiService wikiApiService = WikiniasApiService();
  late Future<List<RecentChanges>> futureRecentChanges;

  @override
  void initState() {
    futureRecentChanges = wikiApiService.fetchNiaspediaRecentChanges(limit: 50);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final String url = 'https://nia.wikipedia.org/wiki/Spesial:Perubahan_terbaru?hidebots=1&hideWikibase=1&limit=100&days=30&urlversion=2';
    final double bodyFontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          title: Text('recent_changes', style: TextStyle(fontFamily: 'Gelasio', fontSize: bodyFontSize * 1.0, color: color)).tr(),
          actions: [
            ViewOnWebIconButton(url: url, color: color),
          ],
        ),
        bottomNavigationBar: NiaspediaRecentChangesBottomAppBar(),
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
