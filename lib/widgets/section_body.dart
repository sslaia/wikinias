import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class SectionBody extends StatelessWidget {
  final String text;

  const SectionBody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(text);
  }
}
