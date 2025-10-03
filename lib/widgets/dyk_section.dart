import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../models/dyk.dart';
import '../services/wikinias_api_service.dart';
import 'featured_section_title.dart';

class DykSection extends StatefulWidget {
  final Color color;

  const DykSection({super.key, required this.color});

  @override
  State<DykSection> createState() => _DykSectionState();
}

class _DykSectionState extends State<DykSection> {
  late Future<Dyk?> _futureRandomDyk;
  final WikiniasApiService _wikiApiService = WikiniasApiService();

  @override
  void initState() {
    super.initState();
    _futureRandomDyk = _wikiApiService.fetchRandomDyk();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FeaturedSectionTitle(
          label: 'dyk',
          color: widget.color,
        ),
        const SizedBox(height: 16.0),
        FutureBuilder<Dyk?>(
          future: _futureRandomDyk,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return snapshot.hasData
                ? DykBody(text: snapshot.data!.text)
                : const CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}

class DykBody extends StatelessWidget {
  final String text;

  const DykBody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      text,
      textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 21.0,
            // wordSpacing: 7,
            color: Colors.black87),
    );
  }
}
