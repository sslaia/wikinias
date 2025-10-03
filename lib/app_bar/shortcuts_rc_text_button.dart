import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ShortcutsRcTextButton extends StatelessWidget {
  const ShortcutsRcTextButton({super.key, required this.rcScreen, required this.color});

  final Widget rcScreen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => rcScreen,
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
      child: Text('recent_changes', style: TextStyle(color: color)).tr(),
    );
  }
}
