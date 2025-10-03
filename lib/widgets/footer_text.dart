import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FooterText extends StatelessWidget {
  const FooterText({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 14.0,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    ).tr();
  }
}
