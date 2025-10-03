import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'language_selection_button.dart';

class LanguageSelection extends StatelessWidget {
  const LanguageSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('select_language', style: const TextStyle(color: Colors.black54)).tr(),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // English
            LanguageSelectionButton(language: 'en', label: 'english', color: Color(0xff9b00a1)),
            const SizedBox(width: 16.0),
            // Nias
            LanguageSelectionButton(language: 'id', label: 'nias', color: Color(0xff121298)),
          ],
        ),
      ],
    );
  }
}

