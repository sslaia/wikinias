import 'package:flutter/material.dart';
import 'featured_section_text.dart';
import 'featured_section_title.dart';

class FeaturedSection extends StatefulWidget {
  final String project;
  final Color color;

  const FeaturedSection({
    super.key,
    required this.project,
    required this.color,
  });

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FeaturedSectionTitle(
              label: (widget.project == 'Niaspedia') ? 'featured_article' : ((widget.project == 'Wikikamus') ? 'featured_word' : 'featured_story'),
              color: (widget.project == 'Wikikamus')
                  ? Colors.black87
                  : widget.color),
          const SizedBox(height: 16.0),
          FeaturedSectionText(project: widget.project),
        ],
    );
  }
}
