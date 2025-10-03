import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../models/word.dart';
import '../services/wikinias_api_service.dart';
import 'featured_section_title.dart';

class FeaturedWord extends StatefulWidget {
  final String project;
  final Color color;

  const FeaturedWord({super.key, required this.project, required this.color});

  @override
  State<FeaturedWord> createState() => _FeaturedWordState();
}

class _FeaturedWordState extends State<FeaturedWord> {
  late Future<Word?> _futureRandomWord;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futureRandomWord = _wikiApiService.fetchRandomWord();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeaturedSectionTitle(label: 'featured_word', color: widget.color),
        const SizedBox(height: 16.0),
        FutureBuilder(
          future: _futureRandomWord,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return snapshot.hasData
                ? FeaturedWordBody(data: snapshot.data!)
                : const CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}

class FeaturedWordBody extends StatelessWidget {
  final Word data;

  const FeaturedWordBody({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String featuredWord =
        '<strong>${data.word}:</strong> ${data.definition}';
    return HtmlWidget(
      featuredWord,
      textStyle: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 18.0,
        color: Colors.black87,
      ),
    );
  }
}
