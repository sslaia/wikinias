import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/about_wikinias_app.dart';
import '../data/about_wikinias_community.dart';
import '../data/whats_new.dart';
import '../providers/font_size_provider.dart';
import '../screens/about_screen.dart';

class DrawerAboutSection extends StatelessWidget {
  const DrawerAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return ExpansionTile(
          title: Text(
            'about',
            style: TextStyle(
              fontFamily: 'Gelasio',
              color: Theme.of(context).colorScheme.primary,
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
          children: [
            AboutListTile(
              title: 'community',
              label: 'about_wikinias_community',
              html: aboutWikiniasCommunity,
              icon: Icon(Icons.groups_2_outlined),
              baseFontSize: baseFontSize,
            ),
            AboutListTile(
              title: 'whats_new',
              label: 'whats_new',
              html: whatsNew,
              icon: Icon(Icons.newspaper_outlined),
              baseFontSize: baseFontSize,
            ),
            AboutListTile(
              title: 'app',
              label: 'about_wikinias_app',
              html: aboutWikiniasApp,
              icon: Icon(Icons.smartphone_outlined),
              baseFontSize: baseFontSize,
            ),
          ],
        );
      },
    );
  }
}

class AboutListTile extends StatelessWidget {
  const AboutListTile({
    super.key,
    required this.title,
    required this.label,
    required this.html,
    required this.icon,
    required this.baseFontSize,
  });

  final String title;
  final String label;
  final String html;
  final Widget icon;
  final double baseFontSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(fontSize: baseFontSize),
      ).tr(),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => AboutScreen(title: label, html: html),
          ),
        );
      },
    );
  }
}
