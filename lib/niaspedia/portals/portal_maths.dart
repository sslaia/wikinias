import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PortalMaths extends StatelessWidget {
  const PortalMaths({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('maths').tr()),
      body: Center(
        child: Text(
          "Edöna mufa'anö",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
