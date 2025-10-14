import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'spacer_image.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key, required this.footer});

  final String footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        const SpacerImage(),
        SizedBox(height: 32),
        // Attribution
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(
            footer,
            textStyle: TextStyle(fontSize: 10),
          ),
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }
}
