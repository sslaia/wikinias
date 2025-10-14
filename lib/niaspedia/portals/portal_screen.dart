import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PortalScreen extends StatelessWidget {
  final String label;
  final String title;

  const PortalScreen({super.key, required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    final String newTitle = title.replaceAll('Portal:', '');
    final Color color = Theme.of(context).colorScheme.primary;
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          title: Text(
            label,
            style: TextStyle(fontSize: bodyFontSize * 1.0),
          ).tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ba da'a dania so ngawalö zura sanandrösa ba $newTitle",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Text(
                "Edöna mufa'anö",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 100),
              Text(
                "Oguna'ö manö ua nahia wangalui hadia ba golayama föna",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
