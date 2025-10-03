import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/about_wikinias_app.dart';
import '../data/about_wikinias_community.dart';
import '../data/whats_new.dart';
import '../screens/about_screen.dart';

class DrawerAboutSection extends StatelessWidget {
  const DrawerAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle titleStyle = TextStyle(
      fontFamily: 'Gelasio',
      fontSize: 21,
      fontWeight: FontWeight.w700,
    );

    return ExpansionTile(
      title: Text('about', style: titleStyle).tr(),
      children: [
        AboutListTile(
          title: 'community',
          label: 'about_wikinias_community',
          html: aboutWikiniasCommunity,
          icon: Icon(Icons.diversity_1_outlined),
        ),
        AboutListTile(
          title: 'whats_new',
          label: 'whats_new',
          html: whatsNew,
          icon: Icon(Icons.newspaper_outlined),
        ),
        AboutListTile(
          title: 'app',
          label: 'about_wikinias_app',
          html: aboutWikiniasApp,
          icon: Icon(Icons.smartphone_outlined),
        ),
      ],
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
  });

  final String title;
  final String label;
  final String html;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    const TextStyle itemStyle = TextStyle(
      fontFamily: 'Ubuntu',
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );

    return ListTile(
      leading: icon,
      title: Text(title, style: itemStyle).tr(),
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
