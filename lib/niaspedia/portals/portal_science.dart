import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PortalScience extends StatelessWidget {
  const PortalScience({super.key});

  @override
  Widget build(BuildContext context) {
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;
    final Color color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        title: Text(
          'science',
          style: TextStyle(fontSize: bodyFontSize * 1.0),
        ).tr(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bolt_outlined),
            tooltip: 'Failo data',
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Edöna mufa'anö",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
