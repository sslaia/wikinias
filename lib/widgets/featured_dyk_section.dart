import 'package:flutter/material.dart';
import 'package:wikinias/models/featured_content_item.dart';
import 'section_body.dart';
import 'section_title.dart';

class FeaturedDykSection extends StatelessWidget {
  final FeaturedContentItem? dykData;

  const FeaturedDykSection({super.key, required this.dykData});

  @override
  Widget build(BuildContext context) {
    if (dykData == null || dykData!.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final String text = dykData!.text;
    final Color color = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionTitle(label: 'dyk', color: color),
        const SizedBox(height: 16.0),
        SectionBody(text: text),
      ],
    );
  }
}
