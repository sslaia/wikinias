import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(
      fontFamily: 'Gelasio',
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
    final TextStyle itemStyle = TextStyle(
      fontFamily: 'Gelasio',
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );
    final String image = 'assets/images/songs.webp';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Sinunö')),
        // bottomNavigationBar: BottomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(image, height: 200, fit: BoxFit.fitHeight),
              SizedBox(height: 16),
              Text('Ngawalö zinunö ba li Niha', style: titleStyle),
              SizedBox(height: 16),
              Text("Edöna mufa'anö", style: itemStyle),
              SizedBox(height: 16),
              const SpacerImage(),
              SizedBox(height: 32),
              // Attribution
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HtmlWidget(wikibukuFooter, textStyle: TextStyle(fontSize: 9),),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
