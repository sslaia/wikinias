import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// The text displayed on the BottomAppBar
class SpecialPagesText extends StatelessWidget {
  const SpecialPagesText({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'special_pages',
      style: TextStyle(
        fontFamily: 'CinzelDecorative',
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    ).tr();
  }
}
