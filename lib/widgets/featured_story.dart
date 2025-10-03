import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../models/story.dart';
import '../services/wikinias_api_service.dart';
import 'featured_section_title.dart';

class FeaturedStory extends StatefulWidget {
  final String project;
  final Color color;

  const FeaturedStory({super.key, required this.project, required this.color});

  @override
  State<FeaturedStory> createState() => _FeaturedStoryState();
}

class _FeaturedStoryState extends State<FeaturedStory> {
  late Future<Story?> _futureRandomStory;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futureRandomStory = _wikiApiService.fetchRandomStory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeaturedSectionTitle(label: 'featured_story', color: widget.color),
        const SizedBox(height: 16.0),
        FutureBuilder(
          future: _futureRandomStory,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return snapshot.hasData
                ? FeaturedStoryBody(text: snapshot.data!.text)
                : const CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}

class FeaturedStoryBody extends StatelessWidget {
  final String text;

  const FeaturedStoryBody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      text,
      textStyle: TextStyle(
        fontFamily: 'Gelasio',
        fontSize: 22.0,
        // wordSpacing: 7,
        color: Colors.black87,
      ),
    );
  }
}
