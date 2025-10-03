import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app_bar/drawer_list_item.dart';
import '../../widgets/create_new_page_form.dart';
import '../../constants.dart';

class NiaspediaDrawerSection extends StatelessWidget {
  const NiaspediaDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(npProject.toLowerCase(), style: titleStyle).tr(),
      children: [
        DrawerListItem(
          text: 'create_new_page',
          icon: Icon(Icons.create_outlined),
          destination: CreateNewPageForm(url: npUrl, color: npColor),
        ),
      ],
    );
  }
}
