import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PortalTextButton extends StatelessWidget {
  const PortalTextButton({
    super.key, required this.label, required this.color, required this.destination,
  });

  final String label;
  final Color color;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => destination,
          ),
        );
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: color),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: Color(0xff121298)),
      ).tr(),
    );
  }
}
