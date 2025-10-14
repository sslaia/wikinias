import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wikinias/wikibuku/bible/bible_introduction.dart';

import '../../widgets/flexible_page_header.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import 'bible_chapter_screen.dart';

class BibleScreen extends StatelessWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final String bibleImage = "assets/images/bible.webp";
    final double bodyFontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: color),
              title: Text("Sura Ni'amoni'ö", style: TextStyle(color: color, fontSize: bodyFontSize * 1.0)),
              floating: true,
              expandedHeight: 250,
              flexibleSpace: FlexiblePageHeader(image: bibleImage),
            ),
            SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(bibleIntroduction),
                ),
                Image.asset(
                  "assets/images/ni'owewemagai.webp",
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 16),
                Text("Amabu'ulali Sibohou", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                BooksList(title: "Mataio", chapter: 28),
                BooksList(title: "Mareko", chapter: 16),
                BooksList(title: "Luka", chapter: 24),
                BooksList(title: "Yohane", chapter: 21),
                BooksList(title: "Halöŵö Zinenge", chapter: 28),
                BooksList(title: "Roma", chapter: 16),
                BooksList(title: "Korindro I", chapter: 16),
                BooksList(title: "Korindro II", chapter: 13),
                BooksList(title: "Galatia", chapter: 6),
                BooksList(title: "Efeso", chapter: 6),
                BooksList(title: "Filifi", chapter: 4),
                BooksList(title: "Kolose", chapter: 4),
                BooksList(title: "Tesalonika I", chapter: 5),
                BooksList(title: "Tesalonika II", chapter: 3),
                BooksList(title: "Timoteo I", chapter: 6),
                BooksList(title: "Timoteo II", chapter: 4),
                BooksList(title: "Tito", chapter: 3),
                BooksList(title: "Filemo", chapter: 1),
                BooksList(title: "Heberaio", chapter: 13),
                BooksList(title: "Yakobo", chapter: 5),
                BooksList(title: "Fetero I", chapter: 5),
                BooksList(title: "Fetero II", chapter: 3),
                BooksList(title: "Yohane I", chapter: 5),
                BooksList(title: "Yohane II", chapter: 1),
                BooksList(title: "Yohane III", chapter: 1),
                BooksList(title: "Yuda", chapter: 1),
                BooksList(title: "Fama'ele'ö", chapter: 22),
                const SizedBox(height: 16),
                Text("Amabu'ulali  Siföföna", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                BooksList(title: "Moze I", chapter: 50),
                BooksList(title: "Moze II", chapter: 40),
                BooksList(title: "Moze III", chapter: 27),
                BooksList(title: "Moze IV", chapter: 36),
                BooksList(title: "Moze V", chapter: 34),
                BooksList(title: "Yosua", chapter: 24),
                BooksList(title: "Sanguhuku", chapter: 21),
                BooksList(title: "Ruti", chapter: 4),
                BooksList(title: "Samueli I", chapter: 31),
                BooksList(title: "Samueli II", chapter: 24),
                BooksList(title: "Razo I", chapter: 22),
                BooksList(title: "Razo II", chapter: 25),
                BooksList(title: "Nga'ötö I", chapter: 29),
                BooksList(title: "Nga'ötö II", chapter: 36),
                BooksList(title: "Esera", chapter: 10),
                BooksList(title: "Nehemia", chapter: 13),
                BooksList(title: "Esitera", chapter: 10),
                BooksList(title: "Yobi", chapter: 42),
                BooksList(title: "Sinunö", chapter: 150),
                BooksList(title: "Amaedola Zelomo", chapter: 31),
                BooksList(title: "Sangombakha", chapter: 12),
                BooksList(title: "Sinunö Sebua", chapter: 8),
                BooksList(title: "Yesaya", chapter: 66),
                BooksList(title: "Yeremia", chapter: 52),
                BooksList(title: "Ngenu-Ngenu Yeremia", chapter: 5),
                BooksList(title: "Hezekieli", chapter: 48),
                BooksList(title: "Danieli", chapter: 12),
                BooksList(title: "Hosea", chapter: 14),
                BooksList(title: "Yoeli", chapter: 3),
                BooksList(title: "Amosi", chapter: 9),
                BooksList(title: "Obadia", chapter: 1),
                BooksList(title: "Yona", chapter: 4),
                BooksList(title: "Mikha", chapter: 7),
                BooksList(title: "Nakhumi", chapter: 3),
                BooksList(title: "Habakuki", chapter: 3),
                BooksList(title: "Sefania", chapter: 3),
                BooksList(title: "Hagai", chapter: 2),
                BooksList(title: "Sakharia", chapter: 14),
                BooksList(title: "Maleakhi", chapter: 4),
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
          ),],
        ),
      ),
    );
  }
}

class BooksList extends StatelessWidget {
  const BooksList({super.key, required this.title, required this.chapter});

  final String title;
  final int chapter;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      children: List.generate(chapter, (index) {
        return ListTile(
          leading: Icon(Icons.auto_stories_outlined),
          title: Text('Faza ${index + 1}', style: Theme.of(context).textTheme.bodySmall),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => BibleChapterScreen(
                  title: "$title/${(index + 1).toString()}",
                  // builder: (context) => BibleChapterScreen(
                  //   title: title,
                  //   chapter: (index + 1).toString(),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
