import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

import '../../app_bar/drawer_list_item.dart';
import '../guides/create_new_entry.dart';

class WikikamusDrawerSection extends StatelessWidget {
  const WikikamusDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('wikikamus', style: titleStyle).tr(),
      children: [
        DrawerListItem(
          text: 'create_new_entry',
          icon: Icon(Icons.auto_stories_outlined),
          destination: CreateNewEntry(),
        ),
      ],
    );
  }
}
