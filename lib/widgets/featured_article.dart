import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../models/article.dart';
import '../services/wikinias_api_service.dart';
import 'featured_section_title.dart';

class FeaturedArticle extends StatefulWidget {
  final String project;
  final Color color;

  const FeaturedArticle({
    super.key,
    required this.project,
    required this.color,
  });

  @override
  State<FeaturedArticle> createState() => _FeaturedArticleState();
}

class _FeaturedArticleState extends State<FeaturedArticle> {
  late Future<Article?> _futureRandomArticle;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futureRandomArticle = _wikiApiService.fetchRandomArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeaturedSectionTitle(label: 'featured_article', color: widget.color),
        const SizedBox(height: 16.0),
        FutureBuilder(
          future: _futureRandomArticle,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return snapshot.hasData
                ? FeaturedArticleBody(text: snapshot.data!.text)
                : const CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}

class FeaturedArticleBody extends StatelessWidget {
  final String text;

  const FeaturedArticleBody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      text,
      textStyle: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 21.0,
        color: Colors.black87,
      ),
    );
  }
}
