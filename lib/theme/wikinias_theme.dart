import 'package:flutter/material.dart';

class WikiniasTheme {
  final Color lightSeed;
  final Color darkSeed;

  const WikiniasTheme({required this.lightSeed, required this.darkSeed});

  static final WikiniasTheme niaspedia = WikiniasTheme(
    lightSeed: const Color(0xff121298),
    darkSeed: const Color(0xff8c9eff),
  );

  static final WikiniasTheme wikikamus = WikiniasTheme(
    lightSeed: const Color(0xffff5722),
    darkSeed: const Color(0xffff8a65),
  );

  static final WikiniasTheme wikibuku = WikiniasTheme(
    lightSeed: const Color(0xff9b00a1),
    darkSeed: const Color(0xff8c9eff),
  );

  static final WikiniasTheme courses = WikiniasTheme(
    lightSeed: const Color(0xff121298),
    darkSeed: const Color(0xff8c9eff),
  );

  static final WikiniasTheme gallery = WikiniasTheme(
    lightSeed: const Color(0xff9b00a1),
    darkSeed: const Color(0xff8c9eff),
  );

}
