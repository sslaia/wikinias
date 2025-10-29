import 'package:flutter/material.dart';
import 'package:wikinias/models/featured_content_item.dart';
import 'section_body.dart';
import 'section_title.dart';

class FeaturedArticleSection extends StatelessWidget {
  final FeaturedContentItem? articleData;

  const FeaturedArticleSection({super.key, required this.articleData});

  @override
  Widget build(BuildContext context) {
    if (articleData == null || articleData!.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final String text = articleData!.text;
    final Color color = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionTitle(label: 'featured_article', color: color),
        const SizedBox(height: 16.0),
        SectionBody(text: text),
      ],
    );
  }
}
