import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'widgets/niaspedia_recent_changes_bottom_app_bar.dart';
import '../models/recent_changes.dart';
import '../services/wikinias_api_service.dart';
import '../constants.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: npColor),
          title: Text('recent_changes', style: TextStyle(fontFamily: 'Gelasio', color: npColor)).tr(),
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
