import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class MainHeaderSection extends StatelessWidget {
  const MainHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double bodyFontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;
    final Color color = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        NormalText(text: 'greeting'),
        const SizedBox(height: 16.0),
        Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) => Text(
            settingsProvider.getProjectName(),
            style: TextStyle(
              fontFamily: 'CinzelDecorative',
              fontSize: bodyFontSize * 1.5,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16.0),
        NormalText(text: 'goal'),
        NormalText(text: 'motto'),
      ],
    );
  }
}

class NormalText extends StatelessWidget {
  const NormalText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall,
      textAlign: TextAlign.center,
    ).tr();
  }
}
