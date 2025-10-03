import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikinias/constants.dart';

class PortalBiology extends StatelessWidget {
  const PortalBiology({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: npColor),
          title: Text('biology').tr(),
        ),
        body: Center(
          child: Text(
            "Edöna mufa'anö",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
