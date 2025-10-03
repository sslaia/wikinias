import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FeaturedSectionTitle extends StatelessWidget {
  const FeaturedSectionTitle({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'CinzelDecorative',
        fontFeatures: [FontFeature.enable('smcp')],
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    ).tr();
  }
}
