import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSelectionButton extends StatelessWidget {
  const LanguageSelectionButton({
    super.key,
    required this.language,
    required this.label,
    required this.color,
  });
  final String language;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.setLocale(Locale(language));
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Color(0xff9b00a1)))),
      ),
      child: Text(label, style: TextStyle(color: color)).tr(),
    );
  }
}
