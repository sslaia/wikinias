import 'package:flutter/material.dart';
import 'package:wikinias/widgets/create_new_page_form.dart';
import 'package:wikinias/app_bar/drawer_list_item.dart';

class NiaspediaDrawerSection extends StatelessWidget {
  const NiaspediaDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'https://nia.m.wikipedia.org/wiki/';

    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        'Niaspedia',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'Gelasio',
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        DrawerListItem(
          text: 'create_new_page',
          icon: const Icon(Icons.create_outlined),
          destination: CreateNewPageForm(url: baseUrl)
        ),
      ],
    );
  }
}
