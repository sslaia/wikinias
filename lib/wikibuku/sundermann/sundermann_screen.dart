import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../widgets/wikibuku_footer.dart';
import 'sundermann_introduction.dart';
import '../../widgets/spacer_image.dart';
import 'sundermann_page_screen.dart';
import '../../constants.dart';

class SundermannScreen extends StatelessWidget {
  const SundermannScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: sundermannColor),
            title: Text('Kamus Sundermann', style: TextStyle(color: sundermannColor))),
        // bottomNavigationBar: BottomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(sundermannImage, height: 200, fit: BoxFit.fitHeight),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(sundermannIntroduction, textStyle: TextStyle()),
              ),
              SizedBox(height: 30),
              Text("Molo'ö börö hurufo", style: titleStyle),
              Wrap(
                children: [
                  SundermannDictionaryPage(title: 'A'),
                  SundermannDictionaryPage(title: 'B'),
                  SundermannDictionaryPage(title: 'C'),
                  SundermannDictionaryPage(title: 'D'),
                  SundermannDictionaryPage(title: 'E'),
                  SundermannDictionaryPage(title: 'F'),
                  SundermannDictionaryPage(title: 'G'),
                  SundermannDictionaryPage(title: 'H'),
                  SundermannDictionaryPage(title: 'I'),
                  SundermannDictionaryPage(title: 'K'),
                  SundermannDictionaryPage(title: 'L'),
                  SundermannDictionaryPage(title: 'M'),
                  SundermannDictionaryPage(title: 'N'),
                  SundermannDictionaryPage(title: 'O'),
                  SundermannDictionaryPage(title: 'Ö'),
                  SundermannDictionaryPage(title: 'R'),
                  SundermannDictionaryPage(title: 'S'),
                  SundermannDictionaryPage(title: 'T'),
                  SundermannDictionaryPage(title: 'U'),
                  SundermannDictionaryPage(title: 'W'),
                  SundermannDictionaryPage(title: 'Ŵ'),
                  SundermannDictionaryPage(title: 'Y'),
                  SundermannDictionaryPage(title: 'Z'),
                ],
              ),
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

class SundermannDictionaryPage extends StatelessWidget {
  final String title;
  const SundermannDictionaryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) =>
                SundermannPageScreen(title: 'Kamus_Nias-Jerman/$title'),
          ),
        );
      },
      child: Text(title),
    );
  }
}
