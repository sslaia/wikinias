import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/niaspedia_titles.dart';
import '../data/wikibuku_titles.dart';
import '../data/wikikamus_titles.dart';
import '../niaspedia/niaspedia_page_screen.dart';
import '../wikibuku/wikibuku_page_screen.dart';
import '../wikikamus/wikikamus_page_screen.dart';

class RandomIconButton extends StatelessWidget {
  const RandomIconButton({
    super.key,
    required this.project,
    required this.color,
  });

  final String project;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final List titles = (project == 'Niaspedia')
        ? niaspediaTitles
        : ((project == 'Wikikamus') ? wikikamusTitles : wikibukuTitles);

    return IconButton(
      tooltip: 'random'.tr(),
      icon: Icon(Icons.shuffle_outlined),
      color: color,
      onPressed: () {
        if (titles.isNotEmpty) {
          final random = Random();
          final index = random.nextInt(titles.length);
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => (project == 'Niaspedia')
                  ? NiaspediaPageScreen(title: titles[index])
                  : ((project == 'Wikikamus')
                        ? WikikamusPageScreen(title: titles[index])
                        : WikibukuPageScreen(title: titles[index])),
            ),
          );
        }
      },
    );
  }
}
