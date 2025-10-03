import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../screens/nias_keyboard_screen.dart';

class ShortcutsKbTextButton extends StatelessWidget {
  const ShortcutsKbTextButton({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) =>
                NiasKeyboardScreen(color: color),
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
      child: Text('nias_keyboard', style: TextStyle(color: color)).tr(),
    );
  }
}