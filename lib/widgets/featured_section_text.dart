import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../models/article.dart';
import '../models/story.dart';
import '../models/word.dart';
import '../services/wikinias_api_service.dart';

class FeaturedSectionText extends StatefulWidget {
  final String project;
  
  const FeaturedSectionText({
    super.key,
    required this.project
  });

  @override
  State<FeaturedSectionText> createState() => _FeaturedSectionTextState();
}

class _FeaturedSectionTextState extends State<FeaturedSectionText> {
  late Future<Article?> _futureRandomArticle;
  late Future<Story?> _futureRandomStory;
  late Future<Word?> _futureRandomWord;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futureRandomArticle = _wikiApiService.fetchRandomArticle();
    _futureRandomStory = _wikiApiService.fetchRandomStory();
    _futureRandomWord = _wikiApiService.fetchRandomWord();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.project == 'Niaspedia') {
      return RandomArticle(futureRandomArticle: _futureRandomArticle);
    } else if (widget.project == 'Wikibuku') {
      return RandomStory(futureRandomStory: _futureRandomStory);
    } else {
      return RandomWord(futureRandomWord: _futureRandomWord);
    }
  }
}

class RandomArticle extends StatelessWidget {
  const RandomArticle({
    super.key,
    required Future<Article?> futureRandomArticle,
  }) : _futureRandomArticle = futureRandomArticle;

  final Future<Article?> _futureRandomArticle;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureRandomArticle,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return snapshot.hasData
            ? HtmlWidget(snapshot.data!.text)
            : const CircularProgressIndicator();
      },
    );
  }
}

class RandomStory extends StatelessWidget {
  const RandomStory({super.key, required Future<Story?> futureRandomStory})
    : _futureRandomStory = futureRandomStory;

  final Future<Story?> _futureRandomStory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureRandomStory,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return snapshot.hasData
            ? HtmlWidget(snapshot.data!.text)
            : const CircularProgressIndicator();
      },
    );
  }
}

class RandomWord extends StatelessWidget {
  const RandomWord({super.key, required Future<Word?> futureRandomWord})
    : _futureRandomWord = futureRandomWord;

  final Future<Word?> _futureRandomWord;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureRandomWord,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return snapshot.hasData
            ? HtmlWidget('${snapshot.data!.word}: ${snapshot.data!.definition}')
            : const CircularProgressIndicator();
      },
    );
  }
}
