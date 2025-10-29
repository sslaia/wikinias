import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.titleSmall;
    return Text(
      label.tr(),
      style: baseStyle?.merge(
        TextStyle(
          fontFamily: 'CinzelDecorative',
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
