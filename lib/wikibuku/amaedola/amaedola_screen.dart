import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wikinias/wikibuku/amaedola/amaedola_introduction.dart';

import '../../widgets/flexible_page_header.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import 'amaedola_page_screen.dart';

class AmaedolaScreen extends StatelessWidget {
  const AmaedolaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final String amaedolaImage = "assets/images/amaedola.webp";
    final TextStyle? titleStyle =
    Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary);
    final TextStyle? headingStyle = Theme.of(context).textTheme.titleMedium
        ?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontFamily: 'Gelasio',
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      // bottomNavigationBar: LabelBottomAppBar(label: title, color: color),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: color),
            title: Text(
              'Ngawalö gamaedola',
              style: titleStyle,
            ),
            floating: true,
            expandedHeight: 250,
            flexibleSpace: FlexiblePageHeader(image: amaedolaImage),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(amaedolaIntroduction),
                ),
                const SizedBox(height: 16),
                Text(
                  "Molo'ö börö hurufo",
                  style: headingStyle,
                ),
                Wrap(
                  children: [
                    AmaedolaList(title: 'A'),
                    AmaedolaList(title: 'B'),
                    AmaedolaList(title: 'D'),
                    AmaedolaList(title: 'E'),
                    AmaedolaList(title: 'F'),
                    AmaedolaList(title: 'G'),
                    AmaedolaList(title: 'H'),
                    AmaedolaList(title: 'I'),
                    AmaedolaList(title: 'K'),
                    AmaedolaList(title: 'L'),
                    AmaedolaList(title: 'M'),
                    AmaedolaList(title: 'N'),
                    AmaedolaList(title: 'O'),
                    AmaedolaList(title: 'R'),
                    AmaedolaList(title: 'S'),
                    AmaedolaList(title: 'T'),
                    AmaedolaList(title: 'U'),
                    AmaedolaList(title: 'W'),
                    AmaedolaList(title: 'Y'),
                    AmaedolaList(title: 'Z'),
                  ],
                ),
                Image.asset(
                  "assets/images/ni'owewemagai.webp",
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 16),
                Text(
                  "Molo'ö tuho",
                  style: headingStyle,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.auto_stories_outlined),
                  title: Text(
                    'Amuata Niha',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            AmaedolaPageScreen(title: 'Amaedola/Amuata Niha'),
                      ),
                    );
                  },
                ),
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
        ],
      ),
    );
  }
}

class AmaedolaList extends StatelessWidget {
  const AmaedolaList({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.auto_stories_outlined),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => AmaedolaPageScreen(title: 'Amaedola/$title'),
          ),
        );
      },
    );
  }
}
