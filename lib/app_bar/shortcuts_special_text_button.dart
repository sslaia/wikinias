import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ShortcutsSpecialTextButton extends StatelessWidget {
  const ShortcutsSpecialTextButton({
    super.key,
    required this.screen,
    required this.text,
    required this.color,
  });

  final Widget screen;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => screen,
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
      child: Text(text, style: TextStyle(color: color)).tr(),
    );
  }
}
