import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class BottomAppBarLabelButton extends StatelessWidget {
  const BottomAppBarLabelButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => TextButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, settingsProvider.getProjectRoute(), (_) => false);
        },
        child: Text(
          label.toLowerCase(),
          style: TextStyle(
            fontFamily: 'CinzelDecorative',
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ).tr(),
      ),
    );
  }
}
