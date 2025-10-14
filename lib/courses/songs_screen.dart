import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('courses_songs_description',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: 50.0),
            Text('courses_coming',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ).tr(),
          ],
        ),
      ),
    );
  }
}
