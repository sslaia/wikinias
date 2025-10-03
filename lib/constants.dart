import 'package:flutter/material.dart';

import 'data/niaspedia_titles.dart';
import 'data/wikibuku_titles.dart';
import 'data/wikikamus_titles.dart';
import 'niaspedia/widgets/niaspedia_footer.dart';
import 'wikibuku/widgets/wikibuku_footer.dart';
import 'wikikamus/widgets/wikikamus_footer.dart';

const TextStyle titleStyle = TextStyle(
  fontFamily: 'Gelasio',
  fontSize: 18,
  fontWeight: FontWeight.w700,
);
const TextStyle itemStyle = TextStyle(
  fontFamily: 'Ubuntu',
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

const englishSelected = SnackBar(
  content: Text('English is selected for the interface language!'),
);
const niasSelected = SnackBar(
  content: Text("Te'oroma'ö ngawalö duria ba li Niha!"),
);

const String npProject = 'Niaspedia';
const String wkProject = 'Wikikamus';
const String wbProject = 'Wikibuku';
const String galleryProject = 'Gallery';
const String coursesProject = 'Courses';
const String settingsProject = 'Settings';

const String npRoute = "/";
const String wkRoute = "/wikikamus";
const String wbRoute = "/wikibuku";
const String galleryRoute = "/gallery";
const String coursesRoute = "/courses";
const String settingsRoute = "/settings";

const String npMainImage = "assets/images/tolögu.webp";
const String npPageImage = "assets/images/ni'ogazi.webp";
const String npSpecialPagesImage = "assets/images/ornament1.webp";

const String wkMainImage = "assets/images/baluse.webp";
const String wkPageImage = "assets/images/ni'obutelai.webp";
const String wkSpecialPagesImage = "assets/images/ornament3.webp";

const String wbMainImage = "assets/images/figa.webp";
const String wbPageImage = "assets/images/bowogafasi.webp";
const String wbSpecialPagesImage = "assets/images/ornament2.webp";

const String amaedolaImage = "assets/images/amaedola.webp";
const String bibleImage = "assets/images/bible.webp";
const String hohoImage = "assets/images/hoho.webp";
const String songsImage = "assets/images/songs.webp";
const String storiesImage = "assets/images/stories.webp";
const String sundermannImage = "assets/images/sundermann.webp";

const String spacerImage = "assets/images/ni'owewemagai.webp";
const String colorBarImage = "assets/images/color_bar.webp";

const String npFooter = niaspediaFooter;
const String wkFooter = wikikamusFooter;
const String wbFooter = wikibukuFooter;

const List npTitles = niaspediaTitles;
const List wkTitles = wikikamusTitles;
const List wbTitles = wikibukuTitles;

final String npUrl = 'https://nia.m.wikipedia.org/wiki/';
final String wkUrl = 'https://nia.m.wiktionary.org/wiki/';
final String wbUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';

const Color npColor = Color(0xff121298);
const Color wbColor = Color(0xff9b00a1);
const Color wkColor = Colors.deepOrange;
const Color coursesColor = Color(0xff121298);
const Color galleryColor = Color(0xff9b00a1);

const Color amaedolaColor = Colors.black87;
const Color bibleColor = Colors.black87;
const Color hohoColor = Colors.black87;
const Color songsColor = Colors.black87;
const Color storiesColor = Colors.black87;
const Color sundermannColor = Colors.black87;

const Color kBlackColor = Colors.black87;
const Color kWhiteColor = Colors.white70;
