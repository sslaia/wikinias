import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/wikibuku_titles.dart';

class RandomIconButton2 extends StatelessWidget {
  const RandomIconButton2({
    super.key,
    required this.onRandomButtonTap,
  });

  final void Function(String title) onRandomButtonTap;

  @override
  Widget build(BuildContext context) {
    final List titles = wikibukuTitles;

    return IconButton(
      tooltip: 'random'.tr(),
      icon: Icon(Icons.shuffle_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        if (titles.isNotEmpty) {
          final random = Random();
          final index = random.nextInt(titles.length);
          onRandomButtonTap(titles[index]);
        }
      },
    );
  }
}
