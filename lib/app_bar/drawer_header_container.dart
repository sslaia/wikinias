import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/providers/settings_provider.dart';

class DrawerHeaderContainer extends StatelessWidget {
  const DrawerHeaderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(settingsProvider.getProjectMainImage()),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'WikiNias',
            style: TextStyle(
              fontFamily: 'CinzelDecorative',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
