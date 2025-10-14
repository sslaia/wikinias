import 'package:flutter/material.dart';

class OpenDrawerButton extends StatelessWidget {
  const OpenDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: Icon(Icons.menu_outlined),
      color: color
    );
  }
}