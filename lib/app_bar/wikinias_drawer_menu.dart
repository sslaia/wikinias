import 'package:flutter/material.dart';

class WikiniasDrawerMenu extends StatelessWidget {
  const WikiniasDrawerMenu({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: children),
    );
  }
}
