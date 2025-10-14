import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import '../providers/settings_provider.dart';
import 'proverbs_screen.dart';
import 'songs_screen.dart';
import 'stories_screen.dart';
import 'youtube_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String project = 'Courses';

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    const ProverbsScreen(),
    const StoriesScreen(),
    const SongsScreen(),
    const YoutubeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'courses',
            style: TextStyle(
              color: color,
              fontFamily: 'CinzelDecorative',
              fontWeight: FontWeight.w700,
            ),
          ).tr(),
          // backgroundColor: color,
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        ),
        drawer: WikiniasDrawerMenu(),
        bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: color,
          type: BottomNavigationBarType.fixed,
          iconSize: 40,
          selectedFontSize: 20,
          selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary, size: 40),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cookie_outlined, size: 48),
              label: 'courses_proverbs'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_outlined, size: 48),
              label: 'courses_stories'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_outlined, size: 48),
              label: 'courses_songs'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined, size: 48),
              // icon: Icon(Icons.star_outline),
              label: 'courses_youtube'.tr(),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: _pages.elementAt(_selectedIndex),
      ),
    ),);
  }
}
