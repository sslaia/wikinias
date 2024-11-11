import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class SelectWiki extends StatelessWidget {
  final String name;
  final String label;
  final String url;
  final Color backgroundColor;
  final Color labelColor;

  const SelectWiki(
      {super.key,
        required this.name,
        required this.label,
        required this.url,
        required this.backgroundColor,
        required this.labelColor});

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => ElevatedButton(
        onPressed: () {
          wiki.setProject(name, url, backgroundColor);
          Navigator.pop(context);
          Navigator.pushNamed(context, '/$label');
          },
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
        child: Text(label, style: TextStyle(color: labelColor)).tr(),
      ),
    );
  }
}
