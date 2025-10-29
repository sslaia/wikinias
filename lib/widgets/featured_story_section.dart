import 'package:flutter/material.dart';
import 'package:wikinias/models/featured_content_item.dart';
import 'section_body.dart';
import 'section_title.dart';

class FeaturedStorySection extends StatelessWidget {
  final FeaturedContentItem? storyData;

  const FeaturedStorySection({super.key, required this.storyData});

  @override
  Widget build(BuildContext context) {
    if (storyData == null || storyData!.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final String text = storyData!.text;
    final Color color = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionTitle(label: 'featured_story', color: color),
        const SizedBox(height: 16.0),
        SectionBody(text: text),
      ],
    );
  }
}
