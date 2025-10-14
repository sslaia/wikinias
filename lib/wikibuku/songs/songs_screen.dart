import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String image = 'assets/images/songs.webp';
    final Color color = Theme.of(context).colorScheme.primary;
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sinunö',
            style: TextStyle(
              fontFamily: 'Gelasio',
              color: color,
              fontSize: bodyFontSize * 1.0,
            ),
          ),
        ),
        // bottomNavigationBar: BottomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(image, height: 200, fit: BoxFit.fitHeight),
              SizedBox(height: 16),
              Text(
                'Ngawalö zinunö ba li Niha',
                style: TextStyle(
                  fontFamily: 'Gelasio',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16),
              Text("Edöna mufa'anö", style: TextStyle(fontFamily: 'Gelasio')),
              SizedBox(height: 16),
              const SpacerImage(),
              SizedBox(height: 32),
              // Attribution
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HtmlWidget(
                  wikibukuFooter,
                  textStyle: TextStyle(fontSize: 9),
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
