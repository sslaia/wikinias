import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PortalHistory extends StatelessWidget {
  const PortalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('history').tr()),
      body: Center(
        child: Text(
          "Edöna mufa'anö",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
