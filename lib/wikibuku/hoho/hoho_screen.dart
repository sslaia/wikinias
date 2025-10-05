import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../widgets/flexible_page_header.dart';
import '../../widgets/spacer_image.dart';
import '../widgets/wikibuku_footer.dart';
import 'hoho_page_screen.dart';
import '../../constants.dart';

class HohoScreen extends StatelessWidget {
  const HohoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: hohoColor),
              title: Text('Ngawalö gamaedola', style: TextStyle(color: hohoColor)),
              floating: true,
              expandedHeight: 250,
              flexibleSpace: FlexiblePageHeader(image: hohoImage),
            ),
            SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 16),
                Text("Ba da'a so ngawalö hoho"),
                SizedBox(height: 32),
                Text("Hoho soya ngawalö", style: titleStyle),
                Column(
                  children: [
                    SizedBox(height: 16),
                    HohoList(title: "Balö huhuo ba we'amöi tome"),
                    HohoList(title: "Böhö tanömö döla - Böhö tanömö gana'a"),
                    HohoList(title: "Hoho ba we'amöi tome ba wangowalu"),
                    HohoList(title: "Hoho ba Wolaya"),
                    HohoList(title: "Hoho ba zi mate"),
                    HohoList(title: "Hoho Fondrorogö Omo Hada Nono Niha"),
                    HohoList(title: "Tanömö zi Siŵa Motöi"),
                  ],
                ),
                Image.asset(
                  "assets/images/ni'owewemagai.webp",
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(height: 16),
                Text("Hikaya Duada Hia", style: titleStyle),
                SizedBox(height: 16),
                Column(
                  children: [
                    HohoList(title: "Böröta Niha Tou ba Danö"),
                    HohoList(title: "Böröta Danö"),
                    HohoList(title: "Fa'atumbu Duada Hia"),
                    HohoList(title: "Lafailo Tou ba Danö"),
                    HohoList(title: "Tanömö zi Siŵa Motöi"),
                    HohoList(title: "Fo'okhöta Duada Hia"),
                    HohoList(title: "Fa'atua-tua Duada Hia"),
                    HohoList(title: "Irugi Inötö Wa'asatua"),
                    HohoList(title: "Böröta Nadua Nuwu (Adu salahi zatua)"),
                    HohoList(title: "Mofanö Dödö Hia"),
                    HohoList(title: "Fa'atohare Lakhömi"),
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
          ),],
        ),
      ),
    );
  }
}

class HohoList extends StatelessWidget {
  const HohoList({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => HohoPageScreen(title: title),
          ),
        );
      },
      child: Text(title),
    );
  }
}
