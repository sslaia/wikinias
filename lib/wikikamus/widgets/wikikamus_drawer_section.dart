import 'package:flutter/material.dart';

import 'package:wikinias/wikikamus/guides/create_new_entry.dart';
import '../../app_bar/drawer_list_item.dart';

class WikikamusDrawerSection extends StatelessWidget {
  const WikikamusDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        'Wikikamus',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'Gelasio',
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        DrawerListItem(
          text: 'create_new_entry',
          icon: const Icon(Icons.create_outlined),
          destination: CreateNewEntry(),
        ),
      ],
    );
  }
}
