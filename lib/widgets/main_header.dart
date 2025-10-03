import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final String project;
  final Color color;

  const MainHeader({super.key, required this.project, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NormalText(
          text: 'greeting',
          fontFamily: 'Ubuntu',
          fontSize: 18.0,
          color: Colors.black87,
        ),
        const SizedBox(height: 24.0),
        // Project name
        NormalText(
          text: project.toLowerCase(),
          fontFamily: 'CinzelDecorative',
          fontSize: 36.0,
          color: color,
        ),
        NormalText(
          text: 'goal',
          fontFamily: 'Ubuntu',
          fontSize: 18.0,
          color: Colors.black87,
        ),
        const SizedBox(height: 24.0),
        NormalText(
          text: 'motto',
          fontFamily: 'Ubuntu',
          fontSize: 14.0,
          color: Colors.black87,
        ),
      ],
    );
  }
}

class NormalText extends StatelessWidget {
  const NormalText({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    required this.color,
  });
  final String text;
  final String fontFamily;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      textAlign: TextAlign.center,
    ).tr();
  }
}
