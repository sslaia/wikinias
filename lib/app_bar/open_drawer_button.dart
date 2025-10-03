import 'package:flutter/material.dart';

class OpenDrawerButton extends StatelessWidget {
  final String project;
  final Color color;

  const OpenDrawerButton({
    super.key,
    required this.project,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: Icon(Icons.menu_outlined),
      color: color
    );
  }
}