import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectLanguage extends StatelessWidget {
  final String label;
  final String language;
  final Color backgroundColor;
  final Color labelColor;

  const SelectLanguage({
    super.key,
    required this.label,
    required this.language,
    required this.backgroundColor,
    required this.labelColor
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.setLocale(Locale(language));
        // Navigator.pop(context);
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: backgroundColor))),
      ),
      child: Text(label, style: TextStyle(color: labelColor)).tr(),
    );
  }
}
