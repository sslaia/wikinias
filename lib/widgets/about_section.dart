import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/data/about_wikinias_community.dart';
import 'package:wikinias/data/whats_new.dart';
import '../data/about_wikinias_app.dart';
import '../screens/about_screen.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('about', style: const TextStyle(color: Colors.black54)).tr(),
        const SizedBox(height: 8.0),
        AboutTextButton(title: 'about_wikinias_community', html: aboutWikiniasCommunity),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AboutTextButton(title: 'about_wikinias_app', html: aboutWikiniasApp),
            const SizedBox(width: 8.0),
            AboutTextButton(title: 'whats_new', html: whatsNew),
          ],
        ),
      ],
    );
  }
}

class AboutTextButton extends StatelessWidget {
  const AboutTextButton({
    super.key, required this.title, required this.html,
  });

  final String title;
  final String html;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => AboutScreen(title: title, html: html),
          ),
        );
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Color(0xff121298)),
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(color: const Color(0xff121298))).tr(),
    );
  }
}