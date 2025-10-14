import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProverbsScreen extends StatefulWidget {
  const ProverbsScreen({super.key});

  @override
  State<ProverbsScreen> createState() => _ProverbsScreenState();
}

class _ProverbsScreenState extends State<ProverbsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('courses_proverbs_description',
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
