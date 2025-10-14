import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class BottomAppBarTextButton extends StatelessWidget {
  const BottomAppBarTextButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => TextButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => settingsProvider.getProjectHome(),
            ),
          );
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
