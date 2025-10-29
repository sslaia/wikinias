import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/app_bar/drawer_about_section.dart';
import 'package:wikinias/app_bar/drawer_font_selection_section.dart';
import 'package:wikinias/app_bar/drawer_header_container.dart';
import 'package:wikinias/app_bar/drawer_language_selection_section.dart';
import 'package:wikinias/app_bar/drawer_project_selection_section.dart';
import 'package:wikinias/app_bar/drawer_update_service_section.dart';

import '../app_bar/wikinias_drawer_menu.dart';
import 'gallery_arts_screen.dart';
import 'gallery_buildings_screen.dart';
import 'gallery_dances_screen.dart';
import 'gallery_others_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final String project = 'Gallery';
  final String image = "assets/images/ni'ogazi.webp";
  final Color color = Color(0xff9b00a1);

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('data_warning_title').tr(),
          content: Text('data_warning_message').tr(),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black12),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ok').tr(),
            ),
          ],
        ),
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _pages = <Widget>[
    const GalleryDancesScreen(),
    const GalleryArtsScreen(),
    const GalleryBuildingsScreen(),
    const GalleryOthersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> galleryScaffold = GlobalKey<ScaffoldState>();

    final List<Widget> drawerChildren = [
      DrawerHeaderContainer(),
      // GalleryDrawerSection(),
      DrawerProjectSelectionSection(),
      DrawerLanguageSelectionSection(),
      DrawerFontSelectionSection(),
      DrawerUpdteServiceSection(),
      DrawerAboutSection(),
    ];

    return SafeArea(
      child: Scaffold(
        key: galleryScaffold,
        appBar: AppBar(
          title: Text(
            'gallery',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'CinzelDecorative',
              fontWeight: FontWeight.w700,
            ),
          ).tr(),
          // backgroundColor: color,
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        ),
        drawer: Builder(
          builder: (drawerContext) {
            return WikiniasDrawerMenu(
              children: drawerChildren,
            );
          },
        ),
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
              icon: Icon(Icons.sports_kabaddi_outlined, size: 48),
              label: 'gallery_dances'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.palette_outlined, size: 48),
              label: 'gallery_arts'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.foundation_outlined, size: 48),
              label: 'gallery_building'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_circle_right_outlined, size: 48),
              // icon: Icon(Icons.star_outline),
              label: 'gallery_others'.tr(),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}
