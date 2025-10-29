import 'package:flutter/material.dart';
import 'package:wikinias/models/word.dart';
import 'section_body.dart';
import 'section_title.dart';

class FeaturedWordSection extends StatelessWidget {
  final Word? wordData;

  const FeaturedWordSection({super.key, required this.wordData});

  @override
  Widget build(BuildContext context) {
    if (wordData == null || wordData!.word.isEmpty || wordData!.definition.isEmpty) {
      return const SizedBox.shrink();
    }

    final String word = wordData!.word;
    final String definition = wordData!.definition;
    final featuredWord = "<strong>$word:</strong> $definition";
    final Color color = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionTitle(label: 'featured_word', color: color),
        const SizedBox(height: 16.0),
        SectionBody(text: featuredWord),
      ],
    );
  }
}

