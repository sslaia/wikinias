import 'package:flutter/material.dart';
import 'section_body.dart';
import 'section_title.dart';

class FeaturedDykSection extends StatelessWidget {
  final Map<String, dynamic> dykData;

  const FeaturedDykSection({super.key, required this.dykData});

  @override
  Widget build(BuildContext context) {
    if (dykData.isEmpty) {
      return const SizedBox.shrink();
    }

    final String text = dykData['text'] ?? 'no_data';
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
