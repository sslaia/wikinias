import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'courses_screen.dart';
import '../app_bar/drawer_list_item.dart';

class CoursesDrawerSection extends StatelessWidget {
  const CoursesDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle titleStyle = TextStyle(
        fontFamily: 'Gelasio',
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: Color(0xff121298)
    );

    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('courses', style: titleStyle).tr(),
      children: [
        DrawerListItem(
          text: 'courses_songs',
          icon: Icon(Icons.school_outlined),
          destination: CoursesScreen(),
        ),
        DrawerListItem(
          text: 'courses_youtube',
          icon: Icon(Icons.school_outlined),
          destination: CoursesScreen(),
        ),
        DrawerListItem(
          text: 'courses_proverbs',
          icon: Icon(Icons.school_outlined),
          destination: CoursesScreen(),
        ),
        DrawerListItem(
          text: 'courses_stories',
          icon: Icon(Icons.school_outlined),
          destination: CoursesScreen(),
        ),
      ],
    );
  }
}