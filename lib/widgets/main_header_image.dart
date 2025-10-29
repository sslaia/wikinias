import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/providers/settings_provider.dart';

class MainHeaderImage extends StatelessWidget {
  const MainHeaderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(settingsProvider.getProjectMainImage()),
            fit: BoxFit.fitHeight,
          )),
    ),);
  }
}
