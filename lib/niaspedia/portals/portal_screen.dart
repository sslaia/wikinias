import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

class PortalScreen extends StatelessWidget {
  final String label;
  final String title;

  const PortalScreen({super.key, required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    final String newTitle = title.replaceAll('Portal:', '');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: npColor),
            title: Text(label).tr()),
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
              Text("Edöna mufa'anö", style: TextStyle(fontWeight: FontWeight.w700)),
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
