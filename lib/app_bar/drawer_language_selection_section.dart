import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DrawerLanguageSelectionSection extends StatelessWidget {
  const DrawerLanguageSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    const englishSelected = SnackBar(
      content: Text('English is selected for the interface language!'),
    );
    const indonesiaSelected = SnackBar(
      content: Text("Bahasa Indonesia untuk bahasa menu!"),
    );
    const niasSelected = SnackBar(
      content: Text("Te'oroma'ö ngawalö duria ba li Niha!"),
    );

    return ExpansionTile(
      title: Text(
        'language'.tr(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'Gelasio',
          fontWeight: FontWeight.w700,
        ),
      ),
      children: [
        ListTile(
          leading: Icon(Icons.language_outlined, color: Color(0xff121298)),
          title: Text('nias'.tr()),
          onTap: () {
            Navigator.pop(context);
            context.setLocale(Locale('nia'));
            ScaffoldMessenger.of(context).showSnackBar(niasSelected);
          },
        ),
        ListTile(
          leading: Icon(Icons.language_outlined, color: Color(0xff121298)),
          title: Text('indonesia'.tr()),
          onTap: () {
            Navigator.pop(context);
            context.setLocale(Locale('id'));
            ScaffoldMessenger.of(context).showSnackBar(indonesiaSelected);
          },
        ),
        ListTile(
          leading: Icon(Icons.language_outlined, color: Color(0xff9b00a1)),
          title: Text('english'.tr()),
          onTap: () {
            Navigator.pop(context);
            context.setLocale(Locale('en'));
            ScaffoldMessenger.of(context).showSnackBar(englishSelected);
          },
        ),
      ],
    );
  }
}
