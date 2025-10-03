import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../models/recent_changes.dart';
import '../services/wikinias_api_service.dart';
import 'widgets/wikibuku_recent_changes_bottom_app_bar.dart';

class WikibukuRecentChangesScreen extends StatefulWidget {
  const WikibukuRecentChangesScreen({super.key});

  @override
  State<WikibukuRecentChangesScreen> createState() => _WikibukuRecentChangesScreenState();
}

class _WikibukuRecentChangesScreenState extends State<WikibukuRecentChangesScreen> {
  final WikiniasApiService wikiniasApiService = WikiniasApiService();
  late Future<List<RecentChanges>> futureRecentChanges;

  @override
  void initState() {
    futureRecentChanges = wikiniasApiService.fetchWikibukuRecentChanges(limit: 50);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: wbColor),
          title: Text('recent_changes', style: TextStyle(color: wbColor)).tr(),
        ),
        bottomNavigationBar: WikibukuRecentChangesBottomAppBar(),
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
