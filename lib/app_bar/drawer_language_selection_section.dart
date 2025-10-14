import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/font_size_provider.dart';

class DrawerLanguageSelectionSection extends StatelessWidget {
  const DrawerLanguageSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    const englishSelected = SnackBar(
      content: Text('English is selected for the interface language!'),
    );
    const niasSelected = SnackBar(
      content: Text("Te'oroma'ö ngawalö duria ba li Niha!"),
    );

    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        final double baseFontSize = fontSizeProvider.scaledFontSize;
        return ExpansionTile(
          title: Text(
            'language',
            style: TextStyle(
              fontFamily: 'Gelasio',
              color: Theme.of(context).colorScheme.primary,
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
          children: [
            ListTile(
              leading: Icon(Icons.language_outlined, color: Color(0xff121298)),
              title: Text('Nias',
              style: TextStyle(
                fontSize: baseFontSize,
                // fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                context.setLocale(Locale('id'));
                ScaffoldMessenger.of(context).showSnackBar(niasSelected);
              },
            ),
            ListTile(
              leading: Icon(Icons.language_outlined, color: Color(0xff9b00a1)),
              title: Text('English',
                style: TextStyle(
                  fontSize: baseFontSize,
                  // fontWeight: FontWeight.bold,
                ),),
              onTap: () {
                context.setLocale(Locale('en'));
                ScaffoldMessenger.of(context).showSnackBar(englishSelected);
              },
            ),
          ],
        );
      },
    );
  }
}
