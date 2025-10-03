import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class DrawerLanguageSelectionSection extends StatelessWidget {
  const DrawerLanguageSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('language', style: titleStyle).tr(),
      children: [
        ListTile(
          leading: Icon(
            Icons.language_outlined,
            color: Color(0xff121298),
          ),
          title: const Text('Nias'),
          onTap: () {
            context.setLocale(Locale('id'));
            ScaffoldMessenger.of(context).showSnackBar(niasSelected);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.language_outlined,
            color: Color(0xff9b00a1),
          ),
          title: const Text('English'),
          onTap: () {
            context.setLocale(Locale('en'));
            ScaffoldMessenger.of(context).showSnackBar(englishSelected);
          },
        ),
      ],
    );
  }
}
