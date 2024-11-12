import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class TitleButton extends StatelessWidget {
  const TitleButton({
    super.key,
    required WebViewController controller,
  }) : _controller = controller;

  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => TextButton(
        onPressed: () {
          if (wiki.name == 'Wb/nia/Wikibooks') {
            _controller.loadRequest(
                Uri.parse('${wiki.url}/wiki/Wb/nia/Olayama'));
          } else {
            _controller.loadRequest(Uri.parse(wiki.url));
          }
        },
        child: Text(
          'WikiNias',
          style: GoogleFonts.cinzelDecorative(
            textStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: (wiki.name == 'Wiktionary')
                    ? Colors.black87
                    : Colors.white70),
          ),
        ),
      ),
    );
  }
}