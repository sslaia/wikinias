import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PortalScience extends StatelessWidget {
  const PortalScience({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('science').tr()),
      body: Center(
        child: Text(
          "Edöna mufa'anö",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
