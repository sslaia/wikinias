import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:wikinias/data/about_wikinias_app.dart';
import 'package:wikinias/data/about_wikinias_community.dart';
import 'package:wikinias/data/whats_new.dart';
import 'package:wikinias/screens/about_screen.dart';

class DrawerAboutSection extends StatelessWidget {
  const DrawerAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'about'.tr(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'Gelasio',
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        AboutListTile(
          title: 'community',
          label: 'about_wikinias_community',
          html: aboutWikiniasCommunity,
          icon: Icon(Icons.groups_2_outlined),
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
    return ListTile(
      leading: icon,
      title: Text(title.tr()),
      onTap: () {
        Navigator.pop(context);
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
