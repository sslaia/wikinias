import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('courses_stories_description',
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: 50.0),
            Text('courses_coming',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ).tr(),
          ],
        ),
      ),
    );
  }
}
