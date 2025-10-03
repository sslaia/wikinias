import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../app_bar/drawer_list_item.dart';
import 'gallery_screen.dart';

class GalleryDrawerSection extends StatelessWidget {
  const GalleryDrawerSection({super.key});

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
      title: Text('gallery', style: titleStyle).tr(),
      children: [
        DrawerListItem(
          text: 'gallery_dances',
          icon: Icon(Icons.photo_library_outlined),
          destination: GalleryScreen(),
        ),
        DrawerListItem(
          text: 'gallery_arts',
          icon: Icon(Icons.photo_library_outlined),
          destination: GalleryScreen(),
        ),
        DrawerListItem(
          text: 'gallery_building',
          icon: Icon(Icons.photo_library_outlined),
          destination: GalleryScreen(),
        ),
        DrawerListItem(
          text: 'gallery_others',
          icon: Icon(Icons.photo_library_outlined),
          destination: GalleryScreen(),
        ),
      ],
    );
  }
}